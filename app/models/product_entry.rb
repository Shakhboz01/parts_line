# total paid might be null, it means provider paid fully at once
class ProductEntry < ApplicationRecord
  belongs_to :provider, optional: true
  belongs_to :product

  validates_presence_of :local_entry
  validates_presence_of :amount
  validates_presence_of :provider, unless: -> { local_entry }
  validates_presence_of :buy_price, unless: -> { local_entry }

  validate :amount_greater_than_amount_sold
  before_commit :set_total_price

  private

  def amount_greater_than_amount_sold
    return errors.add(:base, 'amount is greater than amount sold') if amount < amount_sold
  end

  def set_total_price
    self.total_price = amount * buy_price
  end
end
