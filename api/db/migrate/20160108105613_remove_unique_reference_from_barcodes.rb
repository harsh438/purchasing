class RemoveUniqueReferenceFromBarcodes < ActiveRecord::Migration
  def change
    remove_index(:barcodes, :barcode) if index_exists?(:barcodes, :barcode)
  end
end
