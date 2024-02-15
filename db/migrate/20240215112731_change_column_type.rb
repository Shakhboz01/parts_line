class ChangeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :product_sells, :amount, :decimal, precision: 10, scale: 2, default: 1
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
