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
    Sku.create(sku_attrs(product, option))
  end

  def attrs
    @attrs
  end

  def sku_attrs(product, option)
    attrs.merge!({ product_id: product.id,
                   option_id: option.id })
  end

  def product_attrs
    { name: attrs[:manufacturer_sku],
      price: attrs[:price],
      on_sale: attrs[:on_sale] || '' }
  end

  def option_attrs(product)
    { product_id: product.id,
      name: attrs[:manufacturer_sku] }
  end
end
