class CreateProductSells < ActiveRecord::Migration[7.0]
  def change
    create_table :product_sells do |t|
      t.references :combination_of_local_product, null: true, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :buy_price_in_uzs, precision: 16, scale: 2, default: 0
      t.decimal :buy_price_in_usd, precision: 16, scale: 2, default: 0
      t.decimal :sell_price_in_uzs, precision: 16, scale: 2, default: 0
      t.decimal :sell_price_in_usd, precision: 16, scale: 2, default: 0
      t.decimal :total_profit_in_uzs, default: 0
      t.decimal :total_profit_in_usd, default: 0
      t.boolean :paid_in_usd, default: 0
      t.jsonb :price_data

      t.timestamps
    end
  end
end
