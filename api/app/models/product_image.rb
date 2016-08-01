class ProductImage < ActiveRecord::Base
  self.table_name = :product_image

  belongs_to :product

  default_scope do
    where('deleted_at = "0000-00-00 00:00:00" OR deleted_at IS NULL')
  end

  def as_json
    ProductImageSerializer.new(self).as_json
  end
end
