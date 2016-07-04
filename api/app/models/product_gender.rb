class ProductGender < ActiveRecord::Base
  self.table_name = :product_gender

  include LegacyMappings

  map_attributes product_id: :pid

  belongs_to :product, foreign_key: :pid
end
