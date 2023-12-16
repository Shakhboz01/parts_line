class AddPriceInUsdToDeliveryFromCounterparties < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_from_counterparties, :price_in_usd, :boolean, default: false
  end
end
