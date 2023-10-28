module ProductSells
  class HandleAmountSold < ActiveInteraction::Base
    object :price_data

    def execute
      total_sell_price = 0
      total_buy_price = 0
      total_amount = 0

      price_data.each do |id, data|
        amount = data['amount'].to_i
        sell_price = data['sell_price'].to_f
        service_price = data['service_price'].to_f
        buy_price = data['buy_price'].to_f

        total_sell_price += sell_price * amount
        total_service_price += service_price * amount
        total_buy_price += buy_price * amount
        total_amount += amount
      end

      average_service_price = total_service_price / total_amount
      average_sell_price = total_sell_price / total_amount
      average_buy_price = total_buy_price / total_amount

      {
        average_sell_price: average_sell_price,
        average_buy_price: average_buy_price,
        average_service_price: average_service_price
      }
    end
  end
end
