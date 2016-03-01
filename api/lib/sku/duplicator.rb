class Sku::Duplicator
  def duplicate(options = {})
    options.slice!(:sku, :element_id)
    old_sku = Sku.find_by(sku: options[:sku])
    element = Element.find(options[:element_id].to_i)
    Sku::Generator.new.generate(copy_sku_attributes(old_sku, element))
  end

  private
  def copy_sku_attributes(old_sku, element)
    sku_attrs = old_sku.as_json.symbolize_keys.except(:barcode, :manufacturer_size)
    sku_attrs[:internal_sku] = "#{old_sku.product.id}-#{element.name}"
    sku_attrs[:size] = element.name
    sku_attrs
  end
end
