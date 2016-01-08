class Sku::Exporter
  attr_reader :attrs, :product, :language_product,
              :option, :element, :language_product_option,
              :category, :product_gender, :language_category

  def export(sku)
    return if sku.barcodes.empty?
    return if sku.product.present?

    set_attrs_from(sku)

    create_legacy_records(sku)

    update_order_skus(sku)

    sku.update!(sku_attrs)

    update_purchase_order_legacy_references(sku)

    sku
  end

  private

  def set_attrs_from(sku)
    @attrs = { lead_gender: sku.gender,
               size: sku.size,
               product_name: sku.product_name,
               color: sku.color,
               price: sku.price,
               cost_price: sku.cost_price,
               vendor_id: sku.vendor_id,
               season: sku.season,
               barcode: sku.barcodes.last.barcode,
               manufacturer_sku: sku.manufacturer_sku,
               manufacturer_color: sku.manufacturer_color,
               manufacturer_size: sku.manufacturer_size }
  end

  def create_legacy_records(sku)
    create_product(sku)
    create_language_product(sku)

    if sku.inv_track != 'P'
      create_option(sku)
      create_element(sku)
      create_language_product_option(sku)
    end

    create_category(sku)
    create_language_category(sku)
    create_product_gender(sku)
  end

  def update_order_skus(sku)
    return unless sku.sku.present?
    return unless sku_attrs[:sku].present?

    line_items = OrderLineItem.where(internal_sku: sku.sku)
    line_items.each do |line|
      line.update_attributes!(internal_sku: sku_attrs[:sku])
    end
  end

  def update_purchase_order_legacy_references(sku)
    PurchaseOrderLineItem.where(sku: sku).update_all(pID: sku.product_id,
                                                     oID: sku.option_id,
                                                     orderTool_Barcode: sku.barcodes.first.barcode)
  end

  def create_product(sku)
    @product ||= Product.create!(product_attrs)
  end

  def create_language_product(sku)
    @language_product ||= LanguageProduct.create!(language_product_attrs)
  end

  def create_option(sku)
    @option ||= Option.create!(option_attrs)
  end

  def create_element(sku)
    @element ||= Element.find_or_create_by!(name: attrs[:size])
  end

  def create_language_product_option(sku)
    @language_product_option ||= LanguageProductOption.create!(product_option_attrs)
  end

  def create_category(sku)
    @category ||= Category.find_or_create_by!(id: attrs[:category_id])
  end

  def create_language_category(sku)
    @language_category ||= find_or_create_language_category
  end

  def create_product_gender(sku)
    @product_gender ||= ProductGender.create!(product_gender_attrs)
  end

  def internal_sku
    if option.present?
      "#{product.id}-#{element.id}"
    else
      product.id.to_s
    end
  end

  def sku_option_attrs
    return {} unless option.present?
    { language_product_option_id: language_product_option.id,
      element_id: element.id,
      option_id: option.id }
  end

  def sku_attrs
    attrs.except(:lead_gender, :barcode)
      .merge!({ sku: internal_sku,
                product_id: product.id,
                language_product_id: language_product.id,
                category_id: language_category.id,
                gender: product_gender.gender })
      .merge!(sku_option_attrs)
  end

  def find_or_create_language_category
    category.language_category ||= LanguageCategory.create!(language_category_attrs)

    unless product.categories.include? category
      product.categories << category
    end

    category.language_category
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
