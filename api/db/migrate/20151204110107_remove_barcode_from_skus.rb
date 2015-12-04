class RemoveBarcodeFromSkus < ActiveRecord::Migration
  def change
    remove_column :skus, :barcode
  end
end
