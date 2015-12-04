class CreateSupplierBuyers < ActiveRecord::Migration
  def change
    create_table :supplier_buyers do |t|
      t.string :buyer_name
      t.string :assistant_name
      t.string :department
      t.string :business_unit
      t.references :supplier, index: true
    end
  end
end
