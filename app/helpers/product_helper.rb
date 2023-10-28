module ProductHelper
  def calculate_product_remaining(product)
    product_entries = product.product_entries
    initial_remaining = product.initial_remaining
    # return initial_remaining if product_entries.empty?

    remaining_from_entries = product_entries.sum(:amount) - product_entries.sum(:amount_sold)
    remaining_from_entries + initial_remaining
  end
end
