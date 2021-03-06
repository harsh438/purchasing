class LanguageCategory < ActiveRecord::Base
  self.table_name = :ds_language_categories

  include LegacyMappings
  include Searchable

  map_attributes id: :id,
                 name: :catName,
                 description: :catDesc,
                 language_id: :langID,
                 category_id: :catID

  scope :english, -> { where(language_id: 1) }

  belongs_to :category, foreign_key: :catID
  has_many :products
  has_many :skus, through: :products

  default_scope { order('langID ASC') }

  def self.relevant
    english.where('catId in (select distinct(orderTool_RC) from purchase_orders)')
           .where('langId = 1')
           .order('catName asc')
           .map do |category|
             { id: category.category_id, name: category.name }
           end
  end
end
