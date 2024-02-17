class Buyer < ApplicationRecord
  include ProtectDestroyable

  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :sales
  has_many :sale_from_local_services
  has_many :sale_from_services
  scope :active, -> { where(:active => true) }
  after_create :set_debt

  def calculate_debt_in_usd
    self.sales.price_in_usd.sum(:total_price) - self.sales.price_in_usd.sum(:total_paid)
  end

  def calculate_debt_in_uzs
    self.sales.price_in_uzs.sum(:total_price) - self.sales.price_in_uzs.sum(:total_paid)
  end

  private

  def set_debt
    unless debt_in_usd.nil?
      Sale.create(
        user_id: User.first.id, status: 1,
        payment_type: 0, total_price: debt_in_usd.to_f,
        total_paid: 0, buyer_id: id,
        price_in_usd: true
      )
    end

    return unless debt_in_uzs.nil?

    Sale.create(
      user_id: User.first.id, status: 1,
      payment_type: 0, total_price: debt_in_uzs.to_f,
      total_paid: 0, buyer_id: id,
      price_in_usd: false
    )
  end
end
