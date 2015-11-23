class CreateSupplierDetails < ActiveRecord::Migration
  def change
    create_table :supplier_details do |t|
      t.references :supplier, index: true
      t.string :invoicer_name
      t.string :account_number
      t.string :country_of_origin
      t.boolean :needed_for_intrastat
      t.timestamps
    end
  end
end
