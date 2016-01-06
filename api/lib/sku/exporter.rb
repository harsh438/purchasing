class Sku::Exporter

  def new_sku_attrs_for(generator_attrs)
    @attrs = generator_attrs
    sku_attrs(LanguageProductOption.create(product_option_attrs),
              LanguageProduct.create(language_product_attrs),
              find_or_create_language_category)
  end

  def export(sku)
    return if sku.barcodes.empty?

    @attrs = { lead_gender: sku.gender,
               size: sku.size,
               product_name: sku.product_name,
               color: sku.color,
               price: sku.price,
               cost_price: sku.cost_price,
               vendor_id: sku.vendor_id,
               season: sku.season,
               barcode: sku.barcodes.last.barcode }

    sku.update!(sku_attrs(LanguageProductOption.create(product_option_attrs),
                          LanguageProduct.create(language_product_attrs),
                          find_or_create_language_category))
  end

  private

  def sku_attrs(language_product_option, language_product, language_category)
    attrs.except(:lead_gender, :barcode)
      .merge!({ sku: "#{product.id}-#{element.id}",
                product_id: product.id,
                language_product_id: language_product.id,
                element_id: element.id,
                option_id: option.id,
                language_product_option_id: language_product_option.id,
                category_id: language_category.id,
                gender: product_gender.gender })
  end

  def attrs
    @attrs
  end

  def find_or_create_language_category
    category.language_category ||= LanguageCategory.create(language_category_attrs)

    unless product.categories.include? category
      product.categories << category
    end

    category.language_category
  end

  def product
    @product ||= Product.create(product_attrs)
  end

  def product_gender
    @product_gender ||= ProductGender.create(product_gender_attrs)
  end

  def option
    @option ||= Option.create(option_attrs)
  end

  def category
    @category ||= Category.find_or_create_by!(id: attrs[:category_id])
  end

  def element
    @element ||= Element.find_or_create_by!(name: attrs[:size])
  end

  def product_gender_attrs
    { product_id: product.id,
      gender: attrs[:lead_gender].try(:to_sym) || '' }
  end

  def product_option_attrs
    { language_id: 1,
      name: attrs[:size],
      product_id: product.id,
      option_id: option.id,
      element_id: element.id }
  end

  def language_category_attrs
    { language_id: 1,
      name: attrs[:category_name] || 'Bad Category',
      category_id: category.id }
  end

  def language_product_attrs
    { name: attrs[:product_name],
      product_id: product.id,
      language_id: 1,
      teaser: '',
      description: '',
      email_display: '' }
  end

  def product_attrs
    { manufacturer_sku: "#{attrs[:manufacturer_sku]}-#{attrs[:manufacturer_color]}",
      color: attrs[:color],
      price: attrs[:price],
      cost: attrs[:cost_price],
      on_sale: attrs[:on_sale] || '',
      vendor_id: attrs[:vendor_id],
      season: attrs[:season],
      barcode: attrs[:barcode] }
  end

  def category_attrs
    { parent_id: 0 }
  end

  def option_attrs
    { product_id: product.id,
      name: "#{attrs[:manufacturer_sku]}-#{attrs[:manufacturer_color]}-#{attrs[:manufacturer_size]}"[0..39],
      size: attrs[:manufacturer_size],
      barcode: attrs[:barcode] }
  end
end
