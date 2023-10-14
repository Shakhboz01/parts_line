class Team < ApplicationRecord
  include ProtectDestroyable

  validates_presence_of :name
  validates_uniqueness_of :name

  before_destroy :protect_destroy
  scope :active, -> { where(:active => true)}
end
