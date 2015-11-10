class Element < ActiveRecord::Base
  self.table_name = :mnp_elements

  def self.id_from_option(option_id)
    select('mnp_elements.elementid')
      .joins('LEFT JOIN ds_language_product_options ON
              mnp_elements.elementname = ds_language_product_options.pOption')
      .where('ds_language_product_options.oID = ?', option_id)
      .where('ds_language_product_options.langID = 1').first.try(:element_id)
  end
end
