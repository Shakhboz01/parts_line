class Provider < ApplicationRecord
  include ProtectDestroyable

  has_many :delivery_from_counterparties
  validates_presence_of :name
  validates_uniqueness_of :name
  scope :active, -> { where(:active => true) }

  def calculate_debt
    total_price = delivery_from_counterparties.sum(:total_price)
    total_paid = delivery_from_counterparties.sum(:total_paid)
    total_price - total_paid
  end
end
