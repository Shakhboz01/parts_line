class Sale < ApplicationRecord
  attr_accessor :discount_price
  belongs_to :buyer
  belongs_to :user
  enum status: %i[processing closed]
  enum payment_type: %i[наличные карта click предоплата перечисление дригие]
  has_many :product_sells
  has_one :discount
  has_many :transaction_histories, dependent: :destroy
  before_update :update_product_sales_currencies
  scope :unpaid, -> { where("total_price > total_paid") }
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1"
            where("total_paid < total_price")
          else
            all
          end
        }
  after_save :process_status_change, if: :saved_change_to_status?

  private

  def process_status_change
    if closed? && status_before_last_save != 'closed'
      if enable_to_send_sms
        price_sign = price_in_usd ? '$' : 'сум'
        message =  "#{user.name.upcase} оформил продажу на контрагента\n" \
          "<b>Покупатель</b>: #{buyer.name}\n" \
          "<b>Тип оплаты</b>: #{payment_type}\n" \
          "<b>Итого цена продажи:</b> #{total_price} #{price_sign}\n"
        message << "&#9888<b>Оплачено:</b> #{total_paid} #{price_sign}\n" if total_price > total_paid
        message << "<b>Комментарие:</b> #{comment}\n" if comment.present?
        message << "Нажмите <a href=\"https://#{ENV.fetch('HOST_URL')}/sales/#{self.id}\">здесь</a> для просмотра"
        SendMessage.run(message: message)
      else
        self.enable_to_send_sms = false
      end
    end
  end

  def update_product_sales_currencies
    return if product_sells.empty?

    product_sells.each do |ps|
      ps.update(price_in_usd: price_in_usd)
    end

    self.total_price = product_sells.sum(('sell_price * amount'))
  end
end
