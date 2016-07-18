class KitManager < ActiveRecord::Base
  self.table_name = :sd_kit_manager

  include LegacyMappings

  map_attributes item_code: :itemCode,
                 date_added: :dateAdded

  belongs_to :product, foreign_key: :pID
end
