class AddNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :name, :string

    reversible do |dir|
      dir.up { Order.all.each(&:save!) }
    end
  end
end
