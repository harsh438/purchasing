class Product < ActiveRecord::Base
  self.table_name = :ds_products

  include LegacyMappings
  
  map_attributes id: :pID,
                 name: :pNum,
                 price: :pPrice

  belongs_to :product_detail, foreign_key: :pID
end
