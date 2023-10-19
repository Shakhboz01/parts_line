class Buyer < ApplicationRecord
  include ProtectDestroyable
  validates_presence_of :name
  validates_uniqueness_of :name
  scope :active, -> { where(:active => true)}
end
