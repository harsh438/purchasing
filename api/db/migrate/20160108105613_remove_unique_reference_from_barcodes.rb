class RemoveUniqueReferenceFromBarcodes < ActiveRecord::Migration
  def change
    # unless prod condition added since we never successfully
    # applied this migration to prod and no longer want to
    #
    remove_index :barcodes, :barcode unless Rails.env.production?
  end
end
