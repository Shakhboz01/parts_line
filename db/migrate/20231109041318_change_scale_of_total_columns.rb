class ChangeScaleOfTotalColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :sale_from_services, :total_paid, :decimal, precision: 17, scale: 2
    change_column :sale_from_services, :total_price, :decimal, precision: 17, scale: 2
  end
end
