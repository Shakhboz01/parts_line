# agar tovar prixod shavat i tovara xudamo burordagi boshem, prochiye rasxodi + uxod detalo mishud, badaz tovar prixod shudan, user haminoya medarorat
class CombinationOfLocalProduct < ApplicationRecord
  has_many :expenditures
  has_many :product_sells
  has_one :product_entry
  validates_presence_of :status
  enum status: %i[processing closed]
  before_save :proccess_status_change

  private

  def proccess_status_change
    if closed? && status_before_last_save != "closed"
      total_price = 0
      self.product_sells.each do |product_sell|
        total_price += product_sell.amount * product_sell.buy_price
      end
      expenditures = self.product_sells.sum(:amount)
      total_price += expenditures
      per_price = total_price.to_f / product_entry.amount
      product_entry.update(buy_price: per_price)
    end
  end
end
