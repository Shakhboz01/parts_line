class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.references :combination_of_local_product, null: true, foreign_key: true
      t.decimal :price_in_usd, default: 0
      t.decimal :price_in_uzs, default: 0
      t.boolean :paid_in_usd, default: false
      t.decimal :total_paid
      t.integer :expenditure_type

      t.timestamps
    end
  end
end
