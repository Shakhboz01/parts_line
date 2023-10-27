class DeliveryFromCounterparty < ApplicationRecord
  belongs_to :provider
  has_many :product_entries
  enum payment_type: %i[сум доллар карта дригие]
end
