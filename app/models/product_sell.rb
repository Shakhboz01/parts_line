# product combination usage
# if price_data has a key of `0`, it means from product model, not from prod entry
# increase product initial remaining before_destroy if price data contains 0
class ProductSell < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :sale_from_local_service, optional: true
  belongs_to :product
  validates_presence_of :amount
  enum payment_type: %i[сум доллар карта дригие]
  validate :handle_amount_sold
  validate :varify_combination_is_not_closed
  before_create :increase_amount_sold
  before_create :set_prices_and_profit
  before_destroy :deccrease_amount_sold

  private

  def deccrease_amount_sold
    price_data.each do |data|
      if data[0].to_i.zero?
        product.increment!(:initial_remaining, data[1]["amount"].to_f) and next
      end

      ProductEntry.find(data[0]).decrement!(:amount_sold, data[1]["amount"].to_f)
    end
  end

  def handle_amount_sold
    return if self.persisted? || !new_record? || product.nil?

    ps_validation = ProductSells::CalculateSellAndBuyPrice.run(
      product_sell: self,
    )

    return errors.add(:base, ps_validation.errors.messages.values.flatten[0]) unless ps_validation.valid?

    self.price_data = ps_validation.result[:price_data]
    self.average_prices = ps_validation.result[:average_prices]
  end

  def increase_amount_sold
    price_data.each do |data|
      if data[0].to_i.zero?
        product.decrement!(:initial_remaining, data[1]["amount"].to_f) and next
      end

      ProductEntry.find(data[0].to_i).increment!(:amount_sold, data[1]["amount"].to_f)
    end
  end

  def set_prices_and_profit
    self.buy_price = average_prices["average_buy_price"]
    if combination_of_local_product.present?
      self.sell_price = average_prices["average_buy_price"]
    else
      self.sell_price = sell_price.zero? ? average_prices["average_sell_price"] : sell_price
    end

    profit = sell_price - buy_price
    self.total_profit = profit * amount
  end

  def varify_combination_is_not_closed
    return errors.add(:base, "cannot be edited/created") if !combination_of_local_product.nil? && combination_of_local_product.closed?
  end
end
