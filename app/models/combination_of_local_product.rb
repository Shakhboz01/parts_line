# agar tovar prixod shavat i tovara xudamo burordagi boshem, prochiye rasxodi + uxod detalo mishud, badaz tovar prixod shudan, user haminoya medarorat

class CombinationOfLocalProduct < ApplicationRecord
  has_many :expenditures
  belongs_to :product_entry
  validates_presence_of :status
  enum status: %i[processing closed]
end
