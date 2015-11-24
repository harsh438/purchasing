class AddDiscontinuedFieldToSupplierDetails < ActiveRecord::Migration
  def change
    add_column :supplier_details, :discontinued, :boolean, default: false
    add_index :supplier_details, :discontinued
  end
end
