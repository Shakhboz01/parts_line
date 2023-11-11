class Expenditure < ApplicationRecord
  include ProtectEditAfterDay
  include ProtectDestroyAfterDay
  attr_accessor :rate

  belongs_to :combination_of_local_product, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  has_many :transaction_histories, dependent: :destroy
  validates_presence_of :expenditure_type
  validates_presence_of :price
  enum expenditure_type: %i[другие на_производство на_покупку_товаров]
  enum payment_type: %i[доллар сум карта дригие]

  validate :check_if_total_paid_is_not_more_than_price
  before_save :set_total_paid
  before_destroy :varify_delivery_from_counterparty_is_not_closed

  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1" # The checkbox value when selected
            where("total_paid < price")
          else
            all # No filter when the checkbox is not selected
          end
        }

  private

  def check_if_total_paid_is_not_more_than_price
    return if total_paid.nil?

    errors.add(:base, "cannot be greater than price") if total_paid > price
  end

  def set_total_paid
    return unless total_paid.nil?

    self.total_paid = price.to_f
  end

  def varify_delivery_from_counterparty_is_not_closed
    throw(:abort) if !delivery_from_counterparty.nil? && delivery_from_counterparty.closed?
    throw(:abort) if !combination_of_local_product.nil? && combination_of_local_product.closed?
  end
end
