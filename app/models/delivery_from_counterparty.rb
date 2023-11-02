class DeliveryFromCounterparty < ApplicationRecord
  belongs_to :provider
  has_many :expenditures
  has_many :product_entries
  enum status: %i[processing closed]
  enum payment_type: %i[сум доллар карта дригие]

  before_save :proccess_status_change

  private

  def proccess_status_change
    if closed? && status_before_last_save != "closed"
      total_price = 0
      self.product_entries.each do |product_entry|
        total_price += product_entry.amount * product_entry.buy_price
      end

      self.total_price = total_price
    end
  end
end
