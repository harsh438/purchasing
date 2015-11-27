class AddDefaultToSupplierTerms < ActiveRecord::Migration
  def change
    add_column :supplier_terms, :default, :boolean
  end
end
