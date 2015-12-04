class CreateBarcodes < ActiveRecord::Migration
  def change
    create_table :barcodes do |t|
      t.integer :sku_id
      t.string :barcode
    end
  end
end
