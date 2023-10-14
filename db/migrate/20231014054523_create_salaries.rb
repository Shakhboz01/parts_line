class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.boolean :prepayment
      t.date :month, default: Date.current
      t.references :team, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.decimal :price_in_usd, precision: 10, scale: 2
      t.decimal :price_in_uzs, precision: 25, scale: 2
      t.boolean :paid_in_usd, default: false

      t.timestamps
    end
  end
end
