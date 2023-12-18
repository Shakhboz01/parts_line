class OwnersOperation < ApplicationRecord
  belongs_to :user
  belongs_to :operator, class_name: 'User',
                        foreign_key: 'operator_user_id', optional: true
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  enum operation_type: %i[расход приход]
  # TOTO: Send individual message to telegram
end
