class Provider < ApplicationRecord
  include ProtectDestroyable

  has_many :delivery_from_counterparties
  validates_presence_of :name
  validates_uniqueness_of :name
  scope :active, -> { where(:active => true)}

end
