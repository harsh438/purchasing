class UpdateSkus < ActiveRecord::Migration
  def change
    add_column :skus, :manufacturer_color, :string
    add_column :skus, :manufacturer_size, :string
    add_column :skus, :color, :string
    add_column :skus, :size, :string
    add_column :skus, :color_family, :string
    add_column :skus, :size_scale, :string
    add_column :skus, :cost_price, :decimal, precision: 8, scale: 2
    add_column :skus, :list_price, :decimal, precision: 8, scale: 2
    add_column :skus, :price, :decimal, precision: 8, scale: 2
  end
end
