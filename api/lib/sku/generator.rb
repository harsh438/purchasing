class Sku::Generator
  def sku_from!(attrs)
    @attrs = attrs.with_indifferent_access
    sku = find_sku

    if sku.nil?
      sku = generate_new_sku
    end

    sku
  end

  private

  def find_sku
    if @attrs[:barcode].present?
      sku = find_sku_by_barcode
    else
      sku = find_sku_by_surfdome_size
    end

    if sku.nil?
      sku = find_sku_by_manufacturer_size
    end

    sku
  end

  def find_sku_by_barcode
    barcode = Barcode.find_by(barcode: @attrs[:barcode])
    return nil unless barcode.present?
    Sku.find_by(sku: barcode.sku)
  end

  def find_sku_by_surfdome_size
    Sku.find_by(manufacturer_sku: @attrs[:manufacturer_sku],
                size: @attrs[:size])
  end

  def find_sku_by_manufacturer_size
    Sku.find_by(manufacturer_sku: @attrs[:manufacturer_sku],
                manufacturer_size: @attrs[:manufacturer_size])
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
    @category ||= Category.find_or_create_by!(attrs[:category_id])
  end

  def element
    @element ||= Element.find_or_create_by!(name: attrs[:size])
  end

  def find_or_create_language_category
    category.language_category ||= LanguageCategory.create(language_category_attrs)

    unless product.categories.include? category
      product.categories << category
    end

    category.language_category
  end

  def generate_new_sku
    new_sku_attrs = sku_attrs(LanguageProductOption.create(product_option_attrs),
                              LanguageProduct.create(language_product_attrs),
                              find_or_create_language_category)

    new_sku = Sku.create!(new_sku_attrs.to_h)
    create_barcode_for(new_sku)
    new_sku
  end

  def create_barcode_for(sku)
    return unless attrs[:barcode].present?
    Barcode.create(sku: sku, barcode: attrs[:barcode])
  end

  def attrs
    @attrs
  end

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
      name: attrs[:category_name],
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
