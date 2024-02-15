# product combination usage
# if price_data has a key of `0`, it means from product model, not from prod entry
# increase product initial remaining before_destroy if price data contains 0
class ProductSell < ApplicationRecord
  attr_accessor :initial_remaining
  attr_accessor :product_code_id
  attr_accessor :product_search

  belongs_to :combination_of_local_product, optional: true
  belongs_to :sale_from_local_service, optional: true
  belongs_to :sale
  belongs_to :sale_from_service, optional: true
  belongs_to :product
  has_one :buyer, through: :sale
  has_one :user, through: :sale
  validates_presence_of :amount
  enum payment_type: %i[наличные карта click предоплата перечисление дригие]
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  before_create :decrease_initial_remaining
  after_create :update_sale_currency
  after_create :increase_sale_total_price
  before_update :change_sell_price
  before_destroy :increase_amount_sold
  before_destroy :decrease_sale_total_price

  private

  def increase_sale_total_price
    sale.increment!(:total_price, (sell_price * amount))
  end

  def decrease_sale_total_price
    sale.decrement!(:total_price, (sell_price * amount))
  end

  def increase_amount_sold
    return throw(:abort) if !sale.nil? && sale.closed?

    product.increment!(:initial_remaining, amount)
  end

  def decrease_initial_remaining
    product.decrement!(:initial_remaining, amount)
  end

  def update_sale_currency
    return if sale.nil? || sale.price_in_usd == price_in_usd

    sale.update(price_in_usd: price_in_usd)
  end

  def change_sell_price
    return if price_in_usd == price_in_usd_was

    rate = CurrencyRate.last.rate
    if price_in_usd_was == false && price_in_usd == true
      self.sell_price = sell_price / rate
    elsif price_in_usd_was == true && price_in_usd == false
      self.sell_price = sell_price * rate
    end
  end
end
