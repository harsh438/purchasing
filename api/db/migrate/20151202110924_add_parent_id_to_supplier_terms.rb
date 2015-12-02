class AddParentIdToSupplierTerms < ActiveRecord::Migration
  def change
    add_column :supplier_terms, :parent_id, :integer
  end
end
