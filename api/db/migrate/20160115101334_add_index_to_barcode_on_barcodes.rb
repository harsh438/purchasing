class AddIndexToBarcodeOnBarcodes < ActiveRecord::Migration
  def change
    add_index :barcodes, :barcode
  end
end
