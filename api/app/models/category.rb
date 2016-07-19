class Category < ActiveRecord::Base
  self.table_name = :ds_categories

  include LegacyMappings

  map_attributes id: :catID,
                 parent_id: :parentID

  has_many :language_categories, foreign_key: :catID
  has_many :product_categories, foreign_key: :catID
  has_many :reporting_categories, foreign_key: :catid
end
