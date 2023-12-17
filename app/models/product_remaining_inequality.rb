class ProductRemainingInequality < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates_presence_of :amount
  before_create :change_product_remaining

  private

  def change_product_remaining
    self.previous_amount = product.calculate_product_remaining
    remaining = amount - (product.product_entries.sum(:amount) - product.product_entries.sum(:amount_sold))
    product.update(initial_remaining: remaining)
    SendMessage.run(
      message: "#{user.name} edited Product remaining manually\n" \
               "Product: #{product.name}\n" \
               "Previous amount: #{previous_amount}\n" \
               "Now: #{amount}"
    )
  end
end
