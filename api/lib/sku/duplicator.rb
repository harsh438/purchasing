class Sku::Duplicator
  def duplicate(options = {})
    options.slice!(:sku, :element_id)
    old_sku = Sku.where(sku: options[:sku]).last!
    sku_has_barcode_check(old_sku)
    sku_unsized_check(old_sku)
    element = Element.find(options[:element_id].to_i)
    Sku::Generator.new.generate(copy_sku_attributes(old_sku, element))
  end

  private
  def sku_has_barcode_check(sku)
    if sku.barcodes.count === 0
      raise Exceptions::SkuDuplicationError, 'Please use a SKU with a barcode'
    end
  end

  def sku_unsized_check(sku)
    unless sku.sized?
      raise Exceptions::SkuDuplicationError, 'Please select a SKU with a size'
    end
  end

  def copy_sku_attributes(old_sku, element)
    {
      internal_sku: "#{old_sku.product.id}-#{element.id}",
      size: element.name,
      category_id: old_sku.language_category.category_id,
      vendor_id: old_sku.vendor_id,
      product_name: old_sku.product_name,
      manufacturer_sku: old_sku.manufacturer_sku,
      inv_track: old_sku.inv_track
    }.merge(copy_sku_attributes_visuals(old_sku))
     .merge(copy_sku_attributes_product(old_sku))
  end

  def copy_sku_attributes_product(old_sku)
    {
      product_id: old_sku.product_id,
      price: old_sku.price,
      cost_price: old_sku.cost_price,
      list_price: old_sku.list_price,
      season: old_sku.season,
      category_name: old_sku.category_name,
      on_sale: old_sku.on_sale
    }
  end

  def copy_sku_attributes_visuals(old_sku)
    {
      color: old_sku.color,
      color_family: old_sku.color_family,
      size_scale: old_sku.size_scale,
      gender: old_sku.gender,
      listing_genders: old_sku.listing_genders,
      manufacturer_color: old_sku.manufacturer_color
    }
  end
end
