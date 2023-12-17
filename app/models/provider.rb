class Provider < ApplicationRecord
  include ProtectDestroyable

  has_many :delivery_from_counterparties
  validates_presence_of :name
  validates_uniqueness_of :name
  scope :active, -> { where(:active => true) }

  def calculate_debt_in_usd
    delivery_from_counterparties.price_in_usd.sum(:total_price) - delivery_from_counterparties.price_in_usd.sum(:total_paid)
  end

  def calculate_debt_in_uzs
    delivery_from_counterparties.price_in_uzs.sum(:total_price) - delivery_from_counterparties.price_in_uzs.sum(:total_paid)
  end
end
