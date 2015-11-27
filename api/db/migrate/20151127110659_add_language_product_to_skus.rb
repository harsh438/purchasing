class AddLanguageProductToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :language_product_id, :integer
  end
end
