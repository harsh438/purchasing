class AddTimestampToVendors < ActiveRecord::Migration
  def change
    add_column(:ds_vendors, :created_at, :datetime)
    add_column(:ds_vendors, :updated_at, :datetime)
  end
end
