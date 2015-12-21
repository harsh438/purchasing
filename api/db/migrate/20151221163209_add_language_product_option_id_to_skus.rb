class AddLanguageProductOptionIdToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :language_product_option_id, :integer
  end
end
