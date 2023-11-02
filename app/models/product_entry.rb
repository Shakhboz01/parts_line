# total paid might be null, it means provider paid fully at once
# ignored service_price
class ProductEntry < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  belongs_to :product
  belongs_to :storage
  validates :amount, comparison: { greater_than: 0 }
  validates :sell_price, :buy_price, comparison: { greater_than_or_equal_to: 0 }
  validates :sell_price, comparison: { greater_than_or_equal_to: :buy_price }, if: -> { combination_of_local_product_id.nil? }
  validates_presence_of :buy_price, unless: -> { local_entry }

  before_validation :varify_delivery_from_counterparty_is_not_closed
  before_save :set_service_price
  before_update :amount_sold_is_not_greater_than_amount
  before_create :create_combination_for_local_entry
  before_destroy :varify_delivery_from_counterparty_is_not_closed
  # before_save :set_total_price

  private

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
    return errors.add(:base, "amount sold cannot be greater than amount") if amount_sold > amount
  end

  def varify_delivery_from_counterparty_is_not_closed
    throw(:abort) if !delivery_from_counterparty.nil? && delivery_from_counterparty.closed?
  end

  # def set_total_price
  #   self.total_price = amount * buy_price
  # end
end
