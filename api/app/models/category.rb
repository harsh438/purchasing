class Category < ActiveRecord::Base
  self.table_name = :ds_categories

  include LegacyMappings

  map_attributes id: :catID,
                 parent_id: :parentID
end
