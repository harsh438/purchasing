class AddTimestampsToBarcodes < ActiveRecord::Migration
  def change
    add_column :barcodes, :created_at, :datetime
    add_column :barcodes, :updated_at, :datetime
  end
end
