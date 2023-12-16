class TransactionHistory < ApplicationRecord
  belongs_to :sale, optional: true
  belongs_to :sale_from_service, optional: true
  belongs_to :sale_from_local_service, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  belongs_to :expenditure, optional: true
  validates_presence_of :price
  before_create :proccess_increment
  before_destroy :proccess_decrement

  private

  def proccess_increment
    if !sale.nil? && !sale.transaction_histories.empty?
      sale.increment!(:total_paid, price)
    elsif !delivery_from_counterparty.nil? && !delivery_from_counterparty.transaction_histories.empty?
      delivery_from_counterparty.increment!(:total_paid, price)
    elsif !expenditure.nil? && !expenditure.transaction_histories.empty?
      expenditure.increment!(:total_paid, price)
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
