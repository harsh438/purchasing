class CreateMoreOrderLineItemFields < ActiveRecord::Migration
  def change
    add_column :order_line_items, :vendor_id,    :integer
    add_column :order_line_items, :option_id,    :integer
    add_column :order_line_items, :product_name, :string
    add_column :order_line_items, :product_id,   :integer
  end
end
