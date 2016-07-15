class ProductImage < ActiveRecord::Base
  self.table_name = :product_image

  belongs_to :sku, foreign_key: :product_id
end
