module ProductSells
  class HandleAmountSold < ActiveInteraction::Base
    object :product
    array :product_entry_ids
    boolean :action, default: false
    decimal :remaining_amount

    def execute
      product_entries = ProductEntry.where(id: product_entry_ids).order(:created_at)
      price_data = {}
      # take the last sell and buy price iff product.buy or sell_price is zero
      if product.initial_remaining <= 0
        product_sell_price = product.sell_price.zero? ? product_entries.last.sell_price : product.sell_price
        product_buy_price = product.buy_price.zero? ? product_entries.last.buy_price : product.buy_price
        product_service_price = product.sell_price.zero? ? product_entries.last.service_price : product.sell_price
        price_data.merge({ '0': {
            amount: product.remaining_amount,
            sell_price: product_sell_price,
            service_price: product_service_price,
            buy_price: product_buy_price
          }
        })
        product.update(initial_remaining: 0) if action
      end

      product_entries.each do |product_entry|
        difference = product_entry.amount - product_entry.amount_sold
        if difference <= remaining_amount
          price_data.merge({ "#{product_entry.id}": {
              amount: difference,
              sell_price: product_entry.sell_price,
              buy_price: product_entry.buy_price,
              service_price: product_entry.service_price
            }
          })
          remaining_amount -= difference
          product_entry.increment!(:amount_sold, difference) if action
        else
          price_data.merge({ "#{product_entry.id}": {
              amount: remaining_amount,
              sell_price: product_entry.sell_price,
              buy_price: product_entry.buy_price,
              service_price: product_entry.service_price
            }
          })
          product_entry.increment!(:amount_sold, remaining_amount) if action
          remaining_amount = 0
        end
      end

      if remaining_amount.positive?
        price_data.merge({ "#{product_entries.last&.id}": {
            amount: remaining_amount,
            sell_price: product_entries.last&.sell_price,
            buy_price: product_entries.last&.buy_price,
            service_price: product_entries.last&.service_price
          }
        })
        product_entries.last.increment!(:amount_sold, remaining_amount) if action
      end

      ProductSells::FindAverageSellAndBuyPrice.run(price_data: price_data)
    end
  end
end
