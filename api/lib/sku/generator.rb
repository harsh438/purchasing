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
    language_product_option = LanguageProductOption.create(product_option_attrs)

    language_product = LanguageProduct.create(language_product_attrs)

    language_category = LanguageCategory.create(language_category_attrs)

    Sku.create(sku_attrs(language_product_option,
                         language_category,
                         language_product))
  end

  def attrs
    @attrs
  end

  def sku_attrs(language_product_option, language_category, language_product)
    attrs.merge!({ product_id: product.id,
                   language_product_id: language_product.id,
                   element_id: element.id,
                   option_id: language_product_option.id,
                   category_id: language_category.id })
  end

  def element_attrs
    { name: '' }
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
    { name: attrs[:name] || '',
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
