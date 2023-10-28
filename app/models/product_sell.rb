# product combination usage
# if price_data has a key of `0`, it means from product model, not from prod entry
# increase product initial remaining before_destroy if price data contains 0
class ProductSell < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :product
  validates_presence_of :amount
  enum payment_type: %i[сум доллар карта дригие]
  before_save :varify_combination_is_not_closed
  before_create :decrease_amount_sold

  private

  def decrease_amount_sold
    CalculateSellAndBuyPrice.run(product_sell: self)
    # DecreaseAmountSoldFromProductEntry.run(product_sell: self)
  end

  def varify_combination_is_not_closed
    return errors.add(:base, 'cannot be edited/created') if !combination_of_local_product.nil? && combination_of_local_product.closed?
  end
end
