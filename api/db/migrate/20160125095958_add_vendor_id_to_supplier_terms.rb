class AddVendorIdToSupplierTerms < ActiveRecord::Migration
  def change
    add_column :supplier_terms, :vendor_id, :integer
  end
end
