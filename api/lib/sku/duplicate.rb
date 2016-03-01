class Sku::Duplicate
  def create(options = {})
    options.slice!(:sku, :element_id)
    old_sku = Sku.find_by(sku: options[:sku])
    element = Element.find(options[:element_id].to_i)
    sku = nil
    ActiveRecord::Base.transaction do
      new_sku = Sku::Generator.new.generate(copy_sku_attributes(old_sku, element))
      sku = save_sku(new_sku, old_sku)
    end
    sku
  end

  private
  def save_sku(new_sku, old_sku)
    new_sku.product_id = old_sku.product.id
    new_sku.language_product_id = old_sku.language_product_id
    new_sku.save!
    new_sku
  end

  def copy_sku_attributes(old_sku, element)
    sku_attrs = old_sku.as_json.symbolize_keys.except(:barcode, :manufacturer_size)
    sku_attrs[:internal_sku] = "#{old_sku.product.id}-#{element.name}"
    sku_attrs[:size] = element.name
    sku_attrs
  end
end
