class ProductExtend < ActiveRecord::Base
  self.table_name = :sd_product_extend

  belongs_to :product, foreign_key: :pID
end
