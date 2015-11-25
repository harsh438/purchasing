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

  def generate_new_sku
    product = Product.create(product_attrs)
    option = Option.create(option_attrs(product))
    category = Category.create(category_attrs)
    element = Element.create(element_attrs)

    language_product_option = LanguageProductOption.create(product_option_attrs(product, option, element))
    language_product_category = LanguageProductCategory.create(product_category_attrs(category))

    Sku.create(sku_attrs(product, element, language_product_option, language_product_category))
  end

  def attrs
    @attrs
  end

  def sku_attrs(product, element, language_product_option, language_product_category)
    attrs.merge!({ product_id: product.id,
                   element_id: element.id,
                   option_id: language_product_option.id,
                   category_id: language_product_category.id })
  end

  def element_attrs
    { name: '' }
  end

  def product_option_attrs(product, option, element)
    { language_id: 1,
      product_id: product.id,
      option_id: option.id,
      element_id: element.id }
  end

  def product_category_attrs(category)
    { language_id: 1,
      category_id: category.id }
  end

  def product_attrs
    { name: attrs[:manufacturer_sku],
      price: attrs[:price],
      on_sale: attrs[:on_sale] || '' }
  end

  def category_attrs
    { parentID: 0 }
  end

  def option_attrs(product)
    { product_id: product.id,
      name: attrs[:manufacturer_sku] }
  end
end
