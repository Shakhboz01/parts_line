class DeliveryFromCounterparty < ApplicationRecord
  include HandleTransactionHistory
  belongs_to :provider
  has_many :expenditures
  has_many :product_entries
  has_many :transaction_histories, dependent: :destroy
  enum status: %i[processing closed]
  enum payment_type: %i[доллар сум карта дригие]
  scope :unpaid, -> { where("total_price > total_paid") }
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1"
            where("total_paid < total_price")
          else
            all
          end
        }

  def calculate_total_price
    total_price = 0
    self.product_entries.each do |product_entry|
      total_price += product_entry.amount * product_entry.buy_price
    end

    self.total_price = total_price unless closed?
    self.total_paid = total_price unless closed?
    total_price
  end
end
