class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.boolean :local, default: false
      t.boolean :active, default: true
      t.decimal :sell_price_in_usd, precision: 14, scale: 2, default: 0
      t.decimal :sell_price_in_uzs, precision: 14, scale: 2, default: 0
      t.decimal :buy_price_in_usd, precision: 14, scale: 2, default: 0
      t.decimal :buy_price_in_uzs, precision: 14, scale: 2, default: 0
      t.boolean :price_in_usd, default: false
      t.decimal :initial_remaining, precision: 15, scale: 2, default: 0
      t.integer :unit

      t.timestamps
    end
  end
end
