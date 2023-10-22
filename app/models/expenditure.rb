class Expenditure < ApplicationRecord
  include HandleCurrency
  include ProtectEditAfterDay

  attr_accessor :price
  attr_accessor :rate

  belongs_to :combination_of_local_product, optional: true
  validates_presence_of :expenditure_type
  validates_presence_of :price
  enum expenditure_type: %i[на_производство другие]

  before_validation :set_type
  before_create :set_total_paid

  private

  def set_total_paid
    self.total_paid = price.to_f if total_paid.nil?
  end

  def set_type
    return errors.add(:base, 'invalid expenditure type') if combination_of_local_product.nil? && expenditure_type == 'на_производство'
    errors.add(:base, 'cannot be edited/created') if !combination_of_local_product.nil? && combination_of_local_product.closed?
  end
end
