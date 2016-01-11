class AddSkuIdToPurchaseOrders < ActiveRecord::Migration
  def change
    if column_exists?(:purchase_orders, :sku_id)
      unless index_exists?(:purchase_orders, :sku_id)
        add_index :purchase_orders, :sku_id
      end
    else
      add_reference :purchase_orders, :sku, index: true
    end
  end
end
