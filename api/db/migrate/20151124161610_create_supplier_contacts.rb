class CreateSupplierContacts < ActiveRecord::Migration
  def change
    create_table :supplier_contacts do |t|
      t.string :name
      t.string :title
      t.string :mobile
      t.string :landline
      t.string :email
      t.timestamps
      t.references :supplier, index: true
    end
  end
end
