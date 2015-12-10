class Option < ActiveRecord::Base
  self.table_name = :ds_options

  include LegacyMappings

  map_attributes id: :oID,
                 product_id: :pID,
                 parent_id: :parentID,
                 name: :oNum,
                 size: :oSizeL
end
