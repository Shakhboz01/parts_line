# product initial remaining
# if sel_price is set manually(not 0), then it should not be changed
# if initial true but sell_price is 0 then take the first product entry's sell price
# if initial true && sell_price is 0 && (product entry nil || entry's sell price 0) return error so that user can add a sell price
# prod entry's amount_sold can be greater than its amount, in that case, product oversold and send telegram message

module ProductSells
  class CalculateSellAndBuyPrice < ActiveInteraction::Base
    object :product_sell
    boolean :action, default: false

    def execute
      return errors.add(:base, 'amount cannot be zero') if (amount = product_sell.amount).zero?

      product = product_sell.product
      sell_price = product_sell.sell_price
      response = nil
      buy_price = 0
      first_entry = product.product_entries.where('amount > amount_sold').order(id: :desc).last

      if product.initial_remaining.zero?
        return errors.add(:base, "товар #{product.name}, не имеется в складе!") if first_entry.nil?

        response = ProductSells::FindProductEntryIdsUntilAmount(
          product: product,
          remaining_amount: amount,
          active: active
        )
      else
        if (amount < product.initial_remaining) || first_entry.nil?
          if sell_price.zero?
            sel_price = product.sell_price.zero? ? first_entry&.sell_price : product.sell_price
            return errors.add(:base, "please set sell_price to #{product.name}") if sell_price.nil?
          end

          buy_price = product.buy_price.zero? ? first_entry&.buy_price : product.buy_price
          return errors.add(:base, "please set buy_price to #{product.name}") if buy_price.nil?

          price_data = { '0': { amount: amount, sell_price: sell_price, buy_price: buy_price, service_price: sell_price } }
          response = ProductSells::FindAverageSellAndBuyPrice.run(
            price_data: price_data
          )
          # decrease initial_remaining if action true
          product.decrease!(:initial_remaining, amount) if action
        else
          remaining_amount = amount - product.initial_remaining
          response = ProductSells::FindProductEntriesUntilAmount(
            product: product,
            remaining_amount: remaining_amount,
            active: active
          )
        end
      end

      response
    end
  end
end
