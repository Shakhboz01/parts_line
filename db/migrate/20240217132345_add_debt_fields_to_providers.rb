class AddDebtFieldsToProviders < ActiveRecord::Migration[7.0]
  def change
    add_column :providers, :debt_in_uzs, :decimal
    add_column :providers, :debt_in_usd, :decimal
    add_column :buyers, :debt_in_usd, :decimal
    add_column :buyers, :debt_in_uzs, :decimal
  end
end
