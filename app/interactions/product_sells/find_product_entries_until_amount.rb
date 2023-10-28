module ProductSells
  class FindProductEntriesUntilAmount < ActiveInteraction::Base
    decimal :remaining_amount, default: 0
    object :product
    boolean :action, default: false

    def execute
      unsold_product_entries = product.product_entries.where('amount_sold < amount')

      unsold_product_entries.order(:created_at).each do |product_entry|
        difference = product_entry.amount - product_entry.amount_sold

        if difference <= remaining_amount
          product_entries << product_entry
          remaining_amount -= difference
        else
          product_entries << product_entry
          break
        end
      end

      ProductSells::HandleAmountSold.run!(
        product_entry_ids: product_entries.pluck(:id),
        product: product,
        action: action,
        remaining_amount: remaining_amount
      )
    end
  end
end
