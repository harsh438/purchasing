class Category < ActiveRecord::Base
  self.table_name = :ds_categories

  include LegacyMappings

  map_attributes id: :catID,
                 parent_id: :parentID

  has_one :language_category, foreign_key: :catID
  has_one :product_category, foreign_key: :catID
  has_one :reporting_categories, foreign_key: :catid
end
