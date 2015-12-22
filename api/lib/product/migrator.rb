class Product::Migrator
  class NoManufacturerSku < RuntimeError; end
  class InternalSkuAlreadyExists < RuntimeError; end
  class NoLanguageProduct < RuntimeError; end

  attr_writer :kernel

  def migrate
    Product.find_in_batches.with_index do |group, batch|
      group.each { |product| migrate_single(product) }
    end
  end

  def migrate_single(product)
    @product = product
    if product.language_product_options.count > 0
      migrate_product_with_options
    else
      migrate_product_with_no_options
    end

    puts "Migrated product #{product.id}."
  end

  private

  def kernel
    @kernel ||= Kernel
  end

  def puts(*args)
    kernel.puts(*args)
  end

  def migrate_product_with_options
    product.language_product_options.where(language_id: 1).each do |language_option|
      @language_option = language_option

      if ok_to_migrate?
        Sku.create!(sku_attrs)
      else
        puts validation_error
      end
    end
  end

  def migrate_product_with_no_options
    @language_option = nil

    if ok_to_migrate?
      Sku.create!(sku_attrs_with_no_option)
    else
      puts validation_error
    end
  end

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
    if @language_option
      Element.where(name: language_option.name).order(id: :asc).last
    else
      nil
    end
  end

  def internal_sku
    if element.present?
      "#{product.id}-#{element.id}"
    else
      product.id.to_s
    end
  end

  def manufacturer_color
    product.manufacturer_sku.split('-').drop(1).last || ''
  end

  def check_manufacturer_sku
    if !product.manufacturer_sku.present?
      raise NoManufacturerSku, "Skipping `#{internal_sku}` (Product has no manufacturer_sku)..."
    end
  end

  def check_language_product
    if !product.language_product.present?
      raise NoLanguageProduct, "Skipping `#{internal_sku}` (Product has no language_product)..."
    end
  end

  def check_internal_sku
    if Sku.find_by(sku: internal_sku)
      raise InternalSkuAlreadyExists, "Skipping #{internal_sku} (`#{internal_sku}` already exists)..."
    end
  end

  def ok_to_migrate?
    check_manufacturer_sku
    check_language_product
    check_internal_sku
    true
  rescue => e
    puts e
    false
  end

  def sku_attrs
    { sku: internal_sku }
      .merge!(product_attrs)
      .merge!(product_detail_attrs)
      .merge!(language_product_attrs)
      .merge!(language_option_attrs)
  end

  def sku_attrs_with_no_option
    { sku: internal_sku }
      .merge!(product_attrs)
      .merge!(product_detail_attrs)
      .merge!(language_product_attrs)
  end

  def language_option_attrs
    { language_product_option_id: language_option.id,
      option_id: language_option.option.id,
      element_id: element.id }
  end

  def language_product_attrs
    { product_name: language_product.name,
      language_product_id: language_product.id }
  end

  def product_attrs
    { product_id: product.id,
      manufacturer_sku: product.manufacturer_sku,
      manufacturer_size: language_option.try(:option).try(:size),
      size: language_option.try(:name) || '',
      cost_price: product.cost,
      price: product.price,
      vendor_id: product.vendor_id,
      season: product.season }
  end

  def product_detail_attrs
    { manufacturer_color: manufacturer_color,
      color: product.color,
      gender: product.product_genders.try(:first).try(:gender) }
  end
end
