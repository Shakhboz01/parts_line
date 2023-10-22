class ProductSell < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :product
end
