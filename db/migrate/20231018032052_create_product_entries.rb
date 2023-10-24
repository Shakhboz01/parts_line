class CreateProductEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :product_entries do |t|
      t.decimal :buy_price_in_usd, precision: 10, scale: 2, default: 0
      t.decimal :buy_price_in_uzs, precision: 10, scale: 2, default: 0
      t.decimal :sell_price_in_usd, precision: 10, scale: 2, default: 0
      t.decimal :sell_price_in_uzs, precision: 10, scale: 2, default: 0
      t.boolean :paid_in_usd, default: false
      t.decimal :service_price_in_usd, precision: 10, scale: 2, default: 0
      t.decimal :service_price_in_uzs, precision: 10, scale: 2, default: 0
      t.references :product, null: false, foreign_key: true
      t.decimal :amount, precision: 18, scale: 2, default: 0
      t.decimal :amount_sold, precision: 18, scale: 2, default: 0
      t.string :comment

      t.timestamps
    end
  end
end
