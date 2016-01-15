class AddIndexesToSkus < ActiveRecord::Migration
  def change
    add_index :skus, :season
    add_index :skus, :manufacturer_sku
  end
end
