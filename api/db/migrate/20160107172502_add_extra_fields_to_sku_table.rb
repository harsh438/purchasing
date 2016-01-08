class AddExtraFieldsToSkuTable < ActiveRecord::Migration
  def change
    add_column :skus, :category_name, :string
    add_column :skus, :on_sale, :string
    add_column :skus, :supplier_id, :integer
  end
end
