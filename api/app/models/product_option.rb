class ProductOption < ActiveRecord::Base
  self.table_name = :ds_language_product_options

  def self.oid_from_element(product_id, element_id)
    select('ds_language_product_options.oID')
      .joins('LEFT JOIN mnp_elements ON
              mnp_elements.elementname = ds_language_product_options.pOption')
      .where('mnp_elements.elementid = ?', element_id)
      .where('ds_language_product_options.pID = ?', product_id)
      .where('ds_language_product_options.langID = 1').first.try(:oID)
  end
end
