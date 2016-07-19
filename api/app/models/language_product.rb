class LanguageProduct < ActiveRecord::Base
  self.table_name = :ds_language_products

  include LegacyMappings

  map_attributes id: :lpID,
                 product_id: :pID,
                 language_id: :langID,
                 name: :pName,
                 teaser: :pTeaser,
                 description: :pDesc,
                 email_display: :pCallEmailDisplay

belongs_to :product
end
