class Product < ActiveRecord::Base
  include LegacyMappings
  self.table_name = :ds_products
  map_attributes pID: :id,
                 pNum: :name
end
