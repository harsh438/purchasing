class RemoveSupplierIdFromSkus < ActiveRecord::Migration
  def change
    remove_column :skus, :supplier_id
  end
end
