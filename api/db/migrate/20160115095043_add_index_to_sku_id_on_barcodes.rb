class AddIndexToSkuIdOnBarcodes < ActiveRecord::Migration
  def change
    add_index :barcodes, :sku_id
  end
end
