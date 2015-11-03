class Category < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  self.table_name = :ds_language_categories
  map_attributes id: :id,
                 name: :catName,
                 language_id: :langID,
                 category_id: :catID

  scope :english, -> { where(language_id: 1) }
  def self.relevant
    english.where('catId in (select distinct(orderTool_RC) from purchase_orders)')
           .where('langId = 1')
  end
end
