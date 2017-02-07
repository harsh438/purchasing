class AddProductTypeAndBrandProductTypeToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :product_type, :string
    add_column :skus, :brand_product_name, :string
  end
end
