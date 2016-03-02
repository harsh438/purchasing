class Sku::Duplicator
  def duplicate(options = {})
    options.slice!(:sku, :element_id)
    old_sku = Sku.find_by!(sku: options[:sku])
    sku_has_barcode_check(old_sku)
    sku_unsized_check(old_sku)
    element = Element.find(options[:element_id].to_i)
    Sku::Generator.new.generate(copy_sku_attributes(old_sku, element))
  end

  private
  def sku_has_barcode_check(sku)
    if sku.barcodes.count === 0
      raise Exceptions::SkuDuplicationError, "Please use a SKU with a barcode"
    end
  end

  def sku_unsized_check(sku)
    unless sku.sized?
      raise Exceptions::SkuDuplicationError, "Please select a SKU with a size"
    end
  end

  def copy_sku_attributes(old_sku, element)
    sku_attrs = old_sku.as_json.symbolize_keys.except(:barcode, :manufacturer_size)
    sku_attrs[:internal_sku] = "#{old_sku.product.id}-#{element.name}"
    sku_attrs[:size] = element.name
    sku_attrs
  end
end
