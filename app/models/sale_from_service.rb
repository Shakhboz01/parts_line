class SaleFromService < ApplicationRecord
  belongs_to :buyer
  belongs_to :user, optional: true
  has_many :team_services
  enum status: %i[processing closed]
  enum payment_type: %i[сум доллар карта дригие]
  has_many :product_sells
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
      total_price += product_sell.amount * product_sell.sell_price
    end

    total_price += self.team_services.sum(:total_price)
    total_price
  end
end
