class TransactionHistory < ApplicationRecord
  belongs_to :transactable, polymorphic: true, optional: true
  validates_presence_of :price
  before_create :proccess_increment
  before_destroy :proccess_decrement

  private

  def proccess_increment
    return unless transactable

    transactable.increment!(:total_paid, price)
  end

  def proccess_decrement
    return unless transactable

    transactable.decrement!(:total_paid, price)
  end
end
