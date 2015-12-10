class ProductMigrator
  def migrate
    Product.find_in_batches.with_index do |group, batch|
      group.each { |product| migrate_single(product) }
    end
  end

  def migrate_single(product)
    @product = product
    product.language_product_options.where(language_id: 1).each do |language_option|
      @language_option = language_option

      if ok_to_migrate?
        Sku.create!(sku_attrs)
      else
        puts validation_error
      end
    end

    puts "Migrated product #{product.id}."
  end

  private

  def product
    @product
  end

  def language_option
    @language_option
  end

  def language_product
    @product.language_product
  end

  def validation_error
    @validation_error
  end

  def element
    Element.find_by(name: language_option.name)
  end

  def internal_sku
    "#{product.id}-#{element.id}"
  end

  def manufacturer_color
    product.manufacturer_sku.split('-').drop(1).last || ''
  end

  def ok_to_migrate?
    if !product.manufacturer_sku.present?
      @validation_error = "Skipping `#{internal_sku}` (Product has no manufacturer_sku)..."
      return false
    end

    if Sku.find_by(sku: internal_sku)
      @validation_error = "Skipping #{internal_sku} (`#{internal_sku}` already exists)..."
      return false
    end

    true
  end

  def sku_attrs
    { sku: internal_sku }
      .merge!(product_attrs)
      .merge!(product_detail_attrs)
      .merge!(language_product_attrs)
      .merge!(language_option_attrs)
  end

  def language_option_attrs
    { option_id: language_option.option_id,
      element_id: element.id }
  end

  def language_product_attrs
    { product_name: language_product.name,
      language_product_id: language_product.id }
  end

  def product_attrs
    { product_id: product.id,
      manufacturer_sku: product.manufacturer_sku,
      manufacturer_size: language_option.option.size,
      inv_track: product.inv_track,
      size: language_option.name,
      cost_price: product.cost,
      price: product.price,
      vendor_id: product.vendor_id,
      season: product.season }
  end

  def product_detail_attrs
    { manufacturer_color: manufacturer_color,
      color: manufacturer_color,
      gender: product.try(:product_detail).try(:gender) || '' }
  end
end
