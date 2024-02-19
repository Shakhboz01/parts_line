module ProductSells
  class GenerateReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      rate = CurrencyRate.last.rate
      # calculating debt in uzs
      total_debt = (sale.buyer.calculate_debt_in_usd * rate) + sale.buyer.calculate_debt_in_uzs
      current_total_price = sale.total_price - sale.total_paid
      debt_with_exception = total_debt - current_total_price

      items = [
        ['', '', '', ''],
        ["<b>Tovar</b>", "<b>Soni</b>", "<b>Narxi (1 dona)</b>", "<b>Jami narx</b>"]
      ]
      if debt_with_exception > 0
        items.unshift(["<b></b>", "<b></b>", "<b>Mijozning qarzdorligi:</b>", "<b>#{num_to_usd(debt_with_exception)}</b>"])
      end

      sale.product_sells.each do |product_sell|
        items.push(
          [
            product_sell.product.name,
            product_sell.amount,
            currency_convert(product_sell.price_in_usd, product_sell.sell_price),
            currency_convert(product_sell.price_in_usd, product_sell.sell_price * product_sell.amount)
          ]
        )
      end

      items.push(
        ['', '', '', ''],
        [
        '',
        '',
        '<b>Jami:</b>',
        currency_convert(sale.price_in_usd, sale.total_price)
      ])
      items.push([
        '', '', '<b>Jami to\'landi:</b>', currency_convert(sale.price_in_usd, sale.total_paid)
      ])
      if debt_with_exception > 0
        items.push([
          '', '', "<b>Xariddan keyingi qarzdorlik holati:</b>", "#{num_to_usd(total_debt)}"
        ])
      end
      r = Receipts::Receipt.new(
        title: 'ООО "PARTS-LINE AUTO"',
        font: {
          bold: File.expand_path("./app/assets/fonts/CharisSILB.ttf"),
          italic: File.expand_path("./app/assets/fonts/CharisSILB.ttf"),
          normal: File.expand_path("./app/assets/fonts/Alice-Regular.ttf")
        },
        details: [
          ["Chek nomeri:", sale.id],
          ["Sana:", sale.created_at.strftime("%D - %H:%M")],
          ["To\'lov turi:", sale.payment_type],
          ['', '']
        ],
        company: {
          name: "ООО 'PARTS-LINE AUTO",
          address: "Чупон Ота дом 171",
          phone: '+998915257779',
          email: "parts.line1@mail.ru",
          logo: File.expand_path("./app/assets/images/logo2.png")
        },
        recipient: [
          "<b>Mijoz</b>: #{sale.buyer.name.upcase}"
        ],
        line_items: items,
        footer: "Xaridingiz uchun raxmat. Sizni kutib qolamiz!"
      )

      r.render
    end
  end
end
