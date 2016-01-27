class AddMoreIndexesToSkus < ActiveRecord::Migration
  def change
    add_index :skus, :product_id
    add_index :skus, :option_id
  end
end
