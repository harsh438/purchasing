class AddSkuIdToPurchaseOrders < ActiveRecord::Migration
  def change
    add_reference :purchase_orders, :sku, index: true
  end
end
