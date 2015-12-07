class AddCategoryToSupplierContacts < ActiveRecord::Migration
  def change
    add_column :supplier_contacts, :category, :string
  end
end
