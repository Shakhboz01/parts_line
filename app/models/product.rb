# initial remaining is changable, it can also be negative, but warn if it is a negative
# NOTE sell_price buy price might be 0
class Product < ApplicationRecord
  include ProtectDestroyable

  validates_uniqueness_of :code
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :unit
  belongs_to :product_category
  has_many :product_entries
  has_many :product_remaining_inequalities
  enum unit: %i[ шт. кг метр пачка ]
  scope :active, -> { where(:active => true) }
  scope :local, -> { where(:local => true) }
  after_save :process_initial_remaining_change, if: :saved_change_to_initial_remaining?

  def self.generate_code
    rand(100_000..999_999).to_s
  end

  def calculate_product_remaining
    remaining_from_entries = product_entries.sum(:amount) - product_entries.sum(:amount_sold)
    remaining_from_entries + initial_remaining
  end

  private

  def process_initial_remaining_change
    return if initial_remaining.positive? && !self.product_entries.count.zero?

    SendMessage.run(message: "Остаток товара(#{name}) = #{initial_remaining}", chat: 'warning')
  end
end
