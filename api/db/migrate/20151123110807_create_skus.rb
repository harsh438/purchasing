class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :sku, index: true
      t.string :manufacturer_sku
      t.string :season
      t.integer :product_id
      t.integer :option_id
      t.integer :element_id
      t.timestamps
    end
  end
end
