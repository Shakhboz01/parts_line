class Salary < ApplicationRecord
  include ProtectDestroyable
  attr_accessor :price

  belongs_to :team, optional: true
  belongs_to :user, optional: true

  validates :price, presence: true
  validates_presence_of :month
  validates_presence_of :team, if: -> { user_id.nil? }
  validates_presence_of :user, if: -> { team.nil? }
  validates_absence_of :user, unless: -> { team.nil? }
  validates_absence_of :team, unless: -> { user.nil? }

  before_create :set_prices
  before_update :set_prices

  private

  def set_prices
    rate = CurrencyRate.where(finished_at: nil).last.rate
    self.price = price.to_f
    if paid_in_usd
      self.price_in_usd = price
      self.price_in_uzs = price * rate
    else
      self.price_in_uzs = price
      self.price_in_usd = price.to_f / rate
    end
  end
end
