class AddPoChunkNumberToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :po_chunk_number, :integer
  end
end
