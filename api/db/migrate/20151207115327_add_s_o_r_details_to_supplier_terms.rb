class AddSORDetailsToSupplierTerms < ActiveRecord::Migration
  def change
    add_column :supplier_terms, :sale_or_return_details, :string
  end
end
