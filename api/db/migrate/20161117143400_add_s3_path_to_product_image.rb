class AddS3PathToProductImage < ActiveRecord::Migration
  def change
    add_column :product_image, :s3_path, :string
  end
end
