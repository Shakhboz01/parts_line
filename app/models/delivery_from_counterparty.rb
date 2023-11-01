class DeliveryFromCounterparty < ApplicationRecord
  belongs_to :provider
  has_many :expenditures
  has_many :product_entries
  enum status: %i[processing closed]
  enum payment_type: %i[сум доллар карта дригие]

  before_save :check_if_total_paid_is_not_more_than_price
  before_save :proccess_status_change

  private

  def check_if_total_paid_is_not_more_than_price
    return if !total_paid.nil? && (total_paid <= total_price)
    throw(:abort) and errors.add(:base, 'cannot be greater than price')
  end

  def proccess_status_change
    if closed? && status_before_last_save != 'closed'
      total_price = 0
      self.product_entries.each do |product_entry|
        total_price += product_entry.amount * product_entry.buy_price
      end

      self.total_price = total_price
    end
  end
end
