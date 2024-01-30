module ProductSells
  class GenerateReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      items = [
        ["<b>Товар</b>", "<b>Количество</b>", "<b>Цена</b>", "<b>Итого цена</b>"]
      ]
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

      items.push([
        '<b>Итого:</b>',
        sale.product_sells.sum(:amount),
        '',
        currency_convert(sale.price_in_usd, sale.total_price)
      ])
      items.push([
        '<b>Итого оплачено:</b>',
        '',
        '',
        currency_convert(sale.price_in_usd, sale.total_paid)
      ])
      r = Receipts::Receipt.new(
        title: 'ООО "PARTS-LINE AUTO"',
        font: {
          bold: File.expand_path("./app/assets/fonts/CharisSILB.ttf"),
          italic: File.expand_path("./app/assets/fonts/CharisSILB.ttf"),
          normal: File.expand_path("./app/assets/fonts/Alice-Regular.ttf")
        },
        details: [
          ["Номер чека:", sale.id],
          ["Дата:", sale.created_at.strftime("%D - %H:%M")],
          ['Исполнитель:', sale.user.name],
          ["Тип оплаты:", sale.payment_type]
        ],
        company: {
          name: "ООО 'PARTS-LINE AUTO'",
          address: "Чупон Ота дом 171",
          phone: '+998915257779',
          email: "parts.line1@mail.ru",
          logo: File.expand_path("./app/assets/images/logo2.png")
        },
        recipient: [
          "<b>Покупатель</b>: #{sale.buyer.name}"
        ],
        line_items: items,
        footer: "Спасибо за покупку, ждём вас снова."
      )

      r.render
      downloads_directory = File.join(Dir.home, "Downloads")
      file_path = File.join(downloads_directory, "чек-#{sale.id}-#{DateTime.current.to_i}.pdf")
      r.render_file(file_path)
    end
  end
end
