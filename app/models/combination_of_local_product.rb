# agar tovar prixod shavat i tovara xudamo burordagi boshem, prochiye rasxodi + uxod detalo mishud, badaz tovar prixod shudan, user haminoya medarorat
class CombinationOfLocalProduct < ApplicationRecord
  has_many :expenditures
  has_many :product_sells
  has_one :product_entry
  validates_presence_of :status
  enum status: %i[processing closed]
end
