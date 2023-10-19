class CreateProductEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :product_entries do |t|
      t.boolean :local_entry, default: false
      t.decimal :buy_price, precision: 10, scale: 2, default: 0
      t.decimal :sell_price, precision: 10, scale: 2, default: 0
      t.decimal :service_price, precision: 10, scale: 2, default: 0
      t.references :provider, null: true, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :amount, precision: 18, scale: 2, default: 0
      t.decimal :amount_sold, precision: 18, scale: 2, default: 0
      t.decimal :total_paid, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2, default: 0
      t.string :comment
      t.boolean :return, default: false

      t.timestamps
    end
  end
end
