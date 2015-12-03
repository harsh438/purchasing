class AddBarcodeToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :barcode, :string
  end
end
