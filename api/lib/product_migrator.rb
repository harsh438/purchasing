class ProductMigrator
  def migrate
    Product.find_in_batches.with_index do |group, batch|
      group.each { |product| migrate_single(product) }
    end
  end

  def migrate_single(product)
    @product = product
    product.language_product_options.each do |language_option|
      Sku.create!(sku_attrs(language_option))
    end
  end

  private

  def product
    @product
  end

  def sku_attrs(language_option)
    { sku: "#{product.id}-#{language_option.element_id}",
      manufacturer_sku: product.name,
      manufacturer_color: product.try(:product_detail).try(:color) || '',
      manufacturer_size: product.size,
      size: product.size,
      cost_price: product.cost,
      price: product.price,
      color: product.try(:product_detail).try(:color) || '',
      gender: product.try(:product_detail).try(:gender) || '',
      vendor_id: product.vendor_id,
      product_name: product.language_product.name,
      product_id: product.id,
      language_product_id: product.language_product.id,
      option_id: language_option.option_id,
      element_id: language_option.element_id }
  end
end
