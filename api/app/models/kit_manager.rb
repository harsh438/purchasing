class KitManager < ActiveRecord::Base
  self.table_name = :sd_kit_manager

  include LegacyMappings

  map_attributes item_code: :itemCode,
                 date_added: :dateAdded,
                 source_product_id: :sourcepID,
                 source_option_id: :sourceoID

  belongs_to :product, foreign_key: :pID
  belongs_to :source_product, foreign_key: :sourcepID, class_name: 'Product'
  belongs_to :source_option, foreign_key: :sourceoID, class_name: 'Option'
end
