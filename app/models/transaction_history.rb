class TransactionHistory < ApplicationRecord
  belongs_to :sale, optional: true
  belongs_to :user
  belongs_to :sale_from_service, optional: true
  belongs_to :sale_from_local_service, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  belongs_to :expenditure, optional: true
  validates_presence_of :price
  before_create :proccess_increment
  before_destroy :proccess_decrement
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }

  private

  def proccess_increment
    if !sale.nil? && !sale.transaction_histories.empty?
      sale.increment!(:total_paid, price)
      if price_in_usd != sale.price_in_usd
        self.price_in_usd = !price_in_usd
      end
    elsif !delivery_from_counterparty.nil? && !delivery_from_counterparty.transaction_histories.empty?
      delivery_from_counterparty.increment!(:total_paid, price)
      if price_in_usd != delivery_from_counterparty.price_in_usd
        self.price_in_usd = !price_in_usd
      end
    elsif !expenditure.nil? && !expenditure.transaction_histories.empty?
      expenditure.increment!(:total_paid, price)
      if price_in_usd != expenditure.price_in_usd
        self.price_in_usd = !price_in_usd
      end
    end
  end

  def proccess_decrement
    if !sale.nil?
      sale.decrement!(:total_paid, price)
    elsif !delivery_from_counterparty.nil?
      delivery_from_counterparty.decrement!(:total_paid, price)
    elsif !expenditure.nil?
      expenditure.decrement!(:total_paid, price)
    end
  end
end
