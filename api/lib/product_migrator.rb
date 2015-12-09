class ProductMigrator
  def migrate
    Product.find_in_batches.with_index do |group, batch|
      group.each { |product| migrate_single(product) }
    end
  end

  def migrate_single(product)
    @product = product
    product.language_product_options.where(language_id: 1).each do |language_option|
      Sku.create!(sku_attrs(language_option))
    end
  end

  private

  def product
    @product
  end

  def sku_attrs(language_option)
    { sku: "#{product.id}-#{language_option.element_id}" }
      .merge!(product_attrs)
      .merge!(product_detail_attrs)
      .merge!(language_product_attrs(product.language_product))
      .merge!(language_option_attrs(language_option))
  end

  def language_option_attrs(language_option)
    { option_id: language_option.option_id,
      element_id: Element.find_by(name: language_option.name).id }
  end

  def language_product_attrs(language_product)
    { product_name: language_product.name,
      language_product_id: language_product.id }
  end

  def product_attrs
    { product_id: product.id,
      manufacturer_sku: product.manufacturer_sku,
      manufacturer_size: product.size,
      inv_track: product.inv_track,
      size: product.size,
      cost_price: product.cost,
      price: product.price,
      vendor_id: product.vendor_id }
  end

  def product_detail_attrs
    { manufacturer_color: product.try(:product_detail).try(:color) || '',
      color: product.try(:product_detail).try(:color) || '',
      gender: product.try(:product_detail).try(:gender) || '' }
  end
end
