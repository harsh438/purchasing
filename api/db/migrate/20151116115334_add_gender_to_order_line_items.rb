class AddGenderToOrderLineItems < ActiveRecord::Migration
  def change
    add_column :order_line_items, :gender, :string
  end
end
