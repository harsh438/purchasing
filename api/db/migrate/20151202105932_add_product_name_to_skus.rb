class AddProductNameToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :product_name, :string
  end
end
