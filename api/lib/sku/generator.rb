class Sku::Generator
  def sku_from!(attrs)
    @attrs = attrs
    sku = find_sku

    if sku.nil?
      sku = generate_new_sku
    end

    sku
  end

  private

  def find_sku
    sku = Sku.find_by(manufacturer_sku: @attrs[:manufacturer_sku],
                      size: @attrs[:size])

    if sku.nil?
      sku = Sku.find_by(manufacturer_sku: @attrs[:manufacturer_sku],
                        manufacturer_size: @attrs[:manufacturer_size])
    end

    sku
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

    Sku.create!(new_sku_attrs.merge!(pvx_fields).to_h)
  end

  def pvx_fields
    response = Sku::Api.new.find(man_sku: attrs[:manufacturer_sku],
                                 size: attrs[:manufacturer_size])

    return {} if response.fields.keys.size == 0

    response.fields
  end

  def attrs
    @attrs
  end

  def sku_attrs(language_product_option, language_product, language_category)
    attrs.except(:lead_gender)
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
      gender: attrs[:lead_gender].to_sym }
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
      season: attrs[:season] }
  end

  def category_attrs
    { parent_id: 0 }
  end

  def option_attrs
    { product_id: product.id,
      name: "#{attrs[:manufacturer_sku]}-#{attrs[:manufacturer_color]}-#{attrs[:manufacturer_size]}",
      size: attrs[:manufacturer_size] }
  end
end
