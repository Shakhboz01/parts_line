class Buyer < ApplicationRecord
  include ProtectDestroyable
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :sales
  has_many :sale_from_local_services
  has_many :sale_from_services
  scope :active, -> { where(:active => true) }

  def calculate_debt
    debt_from_sale = self.sales.unpaid.sum(:total_price) - self.sales.unpaid.sum(:total_paid)
    debt_from_sale_from_service = self.sale_from_services.unpaid.sum(:total_price) - self.sale_from_services.unpaid.sum(:total_paid)
    debt_from_sale_from_local_service = self.sale_from_local_services.unpaid.sum(:total_price) - self.sale_from_local_services.unpaid.sum(:total_paid)
    debt_from_sale_from_local_service + debt_from_sale_from_service + debt_from_sale
  end
end
