class Sale < ApplicationRecord
  include HandleTransactionHistory
  belongs_to :buyer
  belongs_to :user
  enum status: %i[processing closed]
  enum payment_type: %i[наличные карта click дригие]
  has_many :product_sells
  has_many :transaction_histories, dependent: :destroy
  scope :unpaid, -> { where("total_price > total_paid") }
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1"
            where("total_paid < total_price")
          else
            all
          end
        }

  def calculate_total_price(enable_to_alter = true)
    total_price = 0
    self.product_sells.each do |product_sell|
      total_price += product_sell.amount * product_sell.sell_price
    end

    if enable_to_alter
      self.total_price = total_price unless closed?
      self.total_paid = total_price unless closed?
    end

    total_price
  end
end
