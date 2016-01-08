class AddUniqueIndexToBarcodes < ActiveRecord::Migration
  def change
    # unless prod condition added since we never successfully
    # applied this migration to prod and no longer want to
    #
    add_index :barcodes, :barcode, unique: true unless Rails.env.production?
  end
end
