class ProductCategory < ActiveRecord::Base
  self.table_name = :ds_product_categories

  include LegacyMappings

  map_attributes product_id: :pID,
                 category_id: :catID,
                 sort_order: :sortOrder

  belongs_to :product, foreign_key: :pID
  belongs_to :category, foreign_key: :catID

  default_scope { includes(:category).order('ds_categories.parentID, ds_product_categories.catID ASC') }
end
