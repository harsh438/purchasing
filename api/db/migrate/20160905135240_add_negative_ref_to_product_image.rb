class AddNegativeRefToProductImage < ActiveRecord::Migration
  def change
    add_column :product_image, :negative_ref, :integer
    add_index :product_image, :negative_ref
  end
end
