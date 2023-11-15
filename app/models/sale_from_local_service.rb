class SaleFromLocalService < ApplicationRecord
  include HandleTransactionHistory
  belongs_to :buyer
  belongs_to :user, optional: true
  has_many :product_sells
  has_many :local_services
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

  def get_total_price
    calculate_total_price
  end

  private

  def calculate_total_price
    total_price = 0
    self.product_sells.each do |product_sell|
      total_price += (product_sell.amount * product_sell.sell_price)
    end

    local_service_price = self.local_services.sum(:price)
    total_price + local_service_price
  end
end
