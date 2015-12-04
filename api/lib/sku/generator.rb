class Sku::Generator
  def sku_from!(attrs)
    @attrs = attrs
    sku = Sku.find_by(manufacturer_sku: attrs[:manufacturer_sku])

    if sku.nil?
      sku = generate_new_sku
    end

    sku
  end

  private

  def product
    @product ||= Product.create(product_attrs)
  end

  def option
    @option ||= Option.create(option_attrs)
  end

  def category
    @category ||= Category.create(category_attrs)
  end

  def element
    @element ||= Element.create(element_attrs)
  end

  def generate_new_sku
    new_sku_attrs = sku_attrs(LanguageProductOption.create(product_option_attrs),
                              LanguageProduct.create(language_product_attrs),
                              LanguageCategory.create(language_category_attrs))

    Sku.create(new_sku_attrs.merge!(pvx_fields))
  end

  def pvx_fields
    response = Sku::Api.new.find(man_sku: attrs[:manufacturer_sku],
                                 size: attrs[:manufacturer_size])

    response.fields
      .except(:barcode)
      .merge!({ barcodes_attributes: [{ barcode: response.fields[:barcode] }] })
  end

  def attrs
    @attrs
  end

  def sku_attrs(language_product_option, language_product, language_category)
    attrs.except(:lead_gender)
         .merge!({ product_id: product.id,
                   language_product_id: language_product.id,
                   element_id: element.id,
                   option_id: language_product_option.id,
                   category_id: language_category.id,
                   gender: attrs[:lead_gender] })
  end

  def element_attrs
    { name: attrs[:size] }
  end

  def product_option_attrs
    { language_id: 1,
      product_id: product.id,
      option_id: option.id,
      element_id: element.id }
  end

  def language_category_attrs
    { language_id: 1,
      category_id: category.id }
  end

  def language_product_attrs
    { name: attrs[:product_name] || '',
      product_id: product.id,
      language_id: 1,
      teaser: '',
      description: '',
      email_display: '' }
  end

  def product_attrs
    { name: attrs[:manufacturer_sku],
      price: attrs[:price],
      on_sale: attrs[:on_sale] || '' }
  end

  def category_attrs
    { parent_id: 0 }
  end

  def option_attrs
    { product_id: product.id,
      name: attrs[:manufacturer_sku] }
  end
end
