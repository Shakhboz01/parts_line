class Salary < ApplicationRecord
  include ProtectDestroyable
  include HandleCurrency
  include ProtectEditAfterDay
  attr_accessor :price
  attr_accessor :rate

  belongs_to :team, optional: true
  belongs_to :user, optional: true

  validates :price, presence: true
  validates_presence_of :month
  validates_presence_of :team, if: -> { user_id.nil? }
  validates_presence_of :user, if: -> { team.nil? }
  validates_absence_of :user, unless: -> { team.nil? }
  validates_absence_of :team, unless: -> { user.nil? }
end
