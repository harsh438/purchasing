class LanguageProductOption < ActiveRecord::Base
  self.table_name = :ds_language_product_options

  include LegacyMappings

  map_attributes language_id: :langID,
                 product_id: :pID,
                 option_id: :oID,
                 name: :pOption,
                 element_id: :elementID

  belongs_to :product, foreign_key: :pID
  belongs_to :option, foreign_key: :oID
  belongs_to :element, foreign_key: :elementID

  def self.oid_from_element(product_id, element_id)
    select_from_element('ds_language_product_options.oID', product_id, element_id).try(:oID)
  end

  def self.id_from_element(product_id, element_id)
    select_from_element('ds_language_product_options.id', product_id, element_id).try(:id)
  end

  private

  def self.select_from_element(selection, product_id, element_id)
    select(selection)
      .joins('LEFT JOIN mnp_elements ON
              mnp_elements.elementname = ds_language_product_options.pOption')
      .where('mnp_elements.elementid = ?', element_id)
      .where('ds_language_product_options.pID = ?', product_id)
      .where('ds_language_product_options.langID = 1')
      .order('id ASC')
      .last
  end
end
