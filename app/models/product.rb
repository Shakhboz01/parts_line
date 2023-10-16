class Product < ApplicationRecord
  include ProtectDestroyable
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :unit
  belongs_to :product_category
  enum unit: %i[ шт кг метр пачка ]
  # NOTE sell_price buy price might be null
end
