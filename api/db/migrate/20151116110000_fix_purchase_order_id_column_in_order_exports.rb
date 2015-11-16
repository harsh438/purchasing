class FixPurchaseOrderIdColumnInOrderExports < ActiveRecord::Migration
  def change
    remove_foreign_key :order_exports, { column: :purchase_order_id }
  end
end
