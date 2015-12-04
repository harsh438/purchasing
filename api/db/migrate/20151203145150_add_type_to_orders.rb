class AddTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :type, :string, default: :reorder
  end
end
