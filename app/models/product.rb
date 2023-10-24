class Product < ApplicationRecord
  include ProtectDestroyable
  include HandleSellAndBuyPrice

  attr_accessor :sell_price, :buy_price

  validates_presence_of :sell_price
  validates_presence_of :buy_price
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :unit
  belongs_to :product_category
  enum unit: %i[ шт кг метр пачка ]
  scope :active, -> { where(:active => true)}
  scope :local, -> { where(:local => true)}
  # NOTE sell_price buy price might be null
end
