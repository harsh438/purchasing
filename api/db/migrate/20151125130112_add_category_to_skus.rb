class AddCategoryToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :category_id, :integer
  end
end
