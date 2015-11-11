class RemoveStatusFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :status, :string, default: 'new'
  end
end
