class AddVendorAndSupplierToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :vendor_id, :integer
    add_column :skus, :supplier_id, :integer
  end
end
