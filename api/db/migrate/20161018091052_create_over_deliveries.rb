class CreateOverDeliveries < ActiveRecord::Migration
  def change
    create_table :over_deliveries do |t|
      t.string :sku
      t.integer :quantity
      t.integer :user_id
      t.string :grn
      t.timestamps null: false
      t.index :sku
    end
  end
end
