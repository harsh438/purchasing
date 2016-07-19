class AddOrderToolRefToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :order_tool_reference, :integer
  end
end
