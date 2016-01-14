class AddSurfdomeColorToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :orderTool_SDcolor, :string
  end
end
