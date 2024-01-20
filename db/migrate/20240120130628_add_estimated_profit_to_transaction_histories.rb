class AddEstimatedProfitToTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_histories, :estimated_profit, :decimal, precision: 17, scale: 2, default: 0
  end
end
