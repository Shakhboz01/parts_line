class LocalService < ApplicationRecord
  belongs_to :sale_from_local_service
  belongs_to :user, optional: true
  validates_presence_of :price
  before_destroy :verify_sale_is_not_closed

  private

  def verify_sale_is_not_closed
    return errors.add(:base, "canot be destroyed") if sale_from_local_service.closed?
  end
end
