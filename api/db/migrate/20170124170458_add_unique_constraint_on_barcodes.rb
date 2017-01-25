class AddUniqueConstraintOnBarcodes < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE barcodes
      ADD CONSTRAINT unique_barcode_per_sku_record UNIQUE (barcode, sku_id)
    SQL
  end
end
