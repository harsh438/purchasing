class AddTimestampToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column(:po_summary, :created_at, :datetime)
    add_column(:po_summary, :updated_at, :datetime)
  end
end
