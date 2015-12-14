class ProductGender < ActiveRecord::Base
  self.table_name = :product_gender

  include LegacyMappings

  map_attributes product_id: :pid
end
