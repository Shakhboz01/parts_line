class DeliveryFromCounterparty < ApplicationRecord
  belongs_to :provider
  has_many :product_entries
end
