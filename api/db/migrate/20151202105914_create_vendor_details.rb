class CreateVendorDetails < ActiveRecord::Migration
  def change
    create_table :vendor_details do |t|
      t.boolean :discontinued
      t.references :vendor, index: true
      t.timestamps
    end
  end
end
