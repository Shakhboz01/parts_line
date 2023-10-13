class Service < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :name
  validates_presence_of :name, :unit, :service_price, :team_fee_in_percent
  enum unit: %i[метр кв кг]
end
