class IncreaseOrderLineItemsOptionIdLength < ActiveRecord::Migration
  def change
    change_column :order_line_items, :option_id, :integer, limit: 8
  end
end
