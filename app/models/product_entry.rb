# total paid might be null, it means provider paid fully at once
class ProductEntry < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  belongs_to :product
  belongs_to :storage
  validates_presence_of :local_entry
  validates_presence_of :amount
  validates_presence_of :buy_price, unless: -> { local_entry }

  validate :amount_greater_than_amount_sold
  before_save :set_service_price
  before_update :amount_sold_is_not_greater_than_amount
  before_create :create_combination_for_local_entry
  # before_save :set_total_price

  private

  def amount_greater_than_amount_sold
    return errors.add(:base, 'amount is greater than amount sold') if !amount.nil? && amount < amount_sold
  end

  def create_combination_for_local_entry
    return unless local_entry

    colp = CombinationOfLocalProduct.create
    self.combination_of_local_product = colp
  end

  def set_service_price
    return unless service_price.nil? || !sell_price.nil?

    self.service_price = sell_price
  end

  def amount_sold_is_not_greater_than_amount
    return errors.add(:base, 'amount sold cannot be greater than amount') if amount_sold > amount
  end

  # def set_total_price
  #   self.total_price = amount * buy_price
  # end
end
