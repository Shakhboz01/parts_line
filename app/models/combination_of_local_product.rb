class CombinationOfLocalProduct < ApplicationRecord
  belongs_to :product_entry
  validates_presence_of :status

  enum status: %i[processing closed]
end
