class ProductImage < ActiveRecord::Base
  self.table_name = :product_image

  belongs_to :product

  def as_json
    ProductImageSerializer.new(self).as_json
  end
end
