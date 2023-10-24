# total paid might be null, it means provider paid fully at once
class ProductEntry < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  belongs_to :product
  has_one :combination_of_local_product
  validates_presence_of :local_entry
  validates_presence_of :amount
  validates_presence_of :buy_price, unless: -> { local_entry }

  validate :amount_greater_than_amount_sold
  after_create :create_combination_for_local_entry
  before_save :set_total_price

  private

  def amount_greater_than_amount_sold
    return errors.add(:base, 'amount is greater than amount sold') if amount < amount_sold
  end

  def create_combination_for_local_entry
    return unless local_entry

    CombinationOfLocalProduct.create(product_entry_id: self.id)
  end

  def set_total_price
    self.total_price = amount * buy_price
  end
end
