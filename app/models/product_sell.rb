# product combination usage
class ProductSell < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :product
  validates_presence_of :amount
  enum payment_type: %i[сум доллар карта дригие]
  before_save :varify_combination_is_not_closed

  private

  def varify_combination_is_not_closed
    return errors.add(:base, 'cannot be edited/created') if !combination_of_local_product.nil? && combination_of_local_product.closed?
  end
end
