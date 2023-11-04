class SaleFromLocalService < ApplicationRecord
  belongs_to :buyer
  belongs_to :user, optional: true
  has_many :product_entries
  enum status: %i[processing closed]
  enum payment_type: %i[сум доллар карта дригие]
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1"
            where("total_paid < total_price")
          else
            all
          end
        }
end
