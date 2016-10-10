class Sku::Exporter
  attr_reader :attrs,
              :product,
              :language_product,
              :option,
              :element,
              :language_product_option,
              :product_gender

  def export(sku)
    return unless sku
    return if sku.barcodes.empty?
    return if sku.product.present? and (!sku.should_be_sized? or sku.option.present?)

    set_attrs_from(sku)
    find_or_create_legacy_records(sku)
    update_order_skus(sku)
    sku.update!(sku_attrs)
    update_purchase_order_legacy_references(sku)

    sku
  end

  private

  def set_attrs_from(sku)
    @attrs = %i(size
                product_name
                color
                price
                cost_price
                vendor_id
                season
                manufacturer_sku
                manufacturer_color
                manufacturer_size
                listing_genders
                inv_track).reduce({}) do |attrs, field|
      attrs.merge(field => sku.send(field))
    end

    @attrs[:lead_gender] = sku.gender
    @attrs[:barcode] = sku.barcodes.last.barcode
  end

  def find_or_create_legacy_records(sku)
    if is_product_present?(sku)
      create_option_legacy_records(sku.product)
    elsif last_existing_sku_by_barcode(sku).present?
      update_sku_legacy_references(sku, last_existing_sku_by_barcode(sku))
    elsif product_by_manufacturer_sku(sku).present? and sku.should_be_sized?
      create_option_legacy_records(product_by_manufacturer_sku(sku))
    else
      create_legacy_records(sku)
    end
  end

  def is_product_present?(sku)
    sku.product.present? and sku.should_be_sized?
  end

  def last_existing_sku_by_barcode(sku)
    Sku.joins(:barcodes).where(barcodes: { barcode: sku.barcodes.first.barcode })
                        .where.not(id: sku.id)
                        .order(created_at: :desc)
                        .first
  end

  def product_by_manufacturer_sku(sku)
    Product.where(manufacturer_sku: attrs[:manufacturer_sku])
           .order(id: :desc)
           .first
  end

  def update_sku_legacy_references(sku, existing_sku)
    @product = sku.product = existing_sku.product
    @language_product = sku.language_product = existing_sku.language_product

    if sku.should_be_sized?
      @option = sku.option = existing_sku.option || create_option
      @element = sku.element = existing_sku.element || create_element
      @language_product_option =
        sku.language_product_option =
          existing_sku.language_product_option || create_language_product_option
    end

    find_or_create_product_gender
  end

  def create_option_legacy_records(product)
    @product = product
    @language_product = product.language_products.find_by(language_id: 1)
    create_option
    create_element
    create_language_product_option
    find_or_create_product_gender
  end

  def create_legacy_records(sku)
    create_product(sku)
    create_language_product

    if sku.should_be_sized?
      create_option
      create_element
      create_language_product_option
    end

    associate_category_to_product(sku)
    find_or_create_product_gender
  end

  def update_order_skus(sku)
    return unless sku.sku.present?
    return unless sku_attrs[:sku].present?

    line_items = OrderLineItem.where(sku: sku)

    line_items.each do |line|
      line.update_attributes!(internal_sku: sku_attrs[:sku],
                              product_id: sku_attrs[:product_id],
                              option_id: sku_attrs[:option_id])
    end
  end

  def update_purchase_order_legacy_references(sku)
    PurchaseOrderLineItem.where(sku: sku).update_all(pID: sku.product_id,
                                                     oID: sku.option_id || 0,
                                                     orderTool_Barcode: sku.barcodes.first.barcode)
  end

  def create_product(sku)
    if @product.blank? and product_attrs[:color].blank?
      error = "Product of sku #{sku.sku} does not have a color "\
              "(exported barcode = '#{product_attrs[:barcode]}')"
      raise ProductWithoutColor.new(product_attrs), error
    end
    @product ||= Product.create!(product_attrs)
  end

  def create_language_product
    @language_product ||= LanguageProduct.create!(language_product_attrs)
  end

  def create_option
    @option ||= Option.create!(option_attrs)
  end

  def create_element
    @element ||= Element.find_or_create_by!(name: attrs[:size])
  end

  def create_language_product_option
    @language_product_option ||= LanguageProductOption.create!(language_product_option_attrs)
  end

  def find_or_create_product_gender
    @product_gender ||= ProductGender.find_or_create_by!(product_gender_attrs)
  end

  def internal_sku
    if option.present?
      "#{product.id}-#{element.id}"
    else
      product.id.to_s
    end
  end

  def sku_attrs
    attrs.except(:lead_gender, :barcode)
      .merge!(sku: internal_sku,
              product_id: product.id,
              language_product_id: language_product.id,
              gender: product_gender.gender)
      .merge!(sku_option_attrs)
  end

  def sku_option_attrs
    return {} unless option.present?
    { language_product_option_id: language_product_option.id,
      element_id: element.id,
      option_id: option.id }
  end

  def associate_category_to_product(sku)
    unless product.categories.include?(sku.language_category.category)
      product.categories << sku.language_category.category
    end

    ReportingCategory.create!(pid: product.id, catid: sku.language_category.category.id)
  end

  def product_attrs
    { manufacturer_sku: attrs[:manufacturer_sku].to_s[0..255],
      color: attrs[:color],
      price: attrs[:price],
      cost: attrs[:cost_price],
      on_sale: attrs[:on_sale] || '',
      vendor_id: attrs[:vendor_id],
      season: attrs[:season],
      barcode: attrs[:barcode],
      listing_genders: attrs[:listing_genders] || '',
      inv_track: attrs[:inv_track] }
  end

  def language_product_attrs
    { name: attrs[:product_name],
      product_id: product.id,
      language_id: 1,
      teaser: '',
      description: '',
      email_display: '' }
  end

  def option_attrs
    { product_id: product.id,
      name: "#{attrs[:manufacturer_sku]}-#{attrs[:manufacturer_size]}"[0..255],
      size: attrs[:manufacturer_size],
      barcode: attrs[:barcode] }
  end

  def language_product_option_attrs
    { language_id: 1,
      name: attrs[:size],
      product_id: product.id,
      option_id: option.id,
      element_id: element.id }
  end

  def product_gender_attrs
    { product_id: product.id,
      gender: attrs[:lead_gender].try(:to_sym) || '' }
  end

  class ProductWithoutColor < StandardError
    attr_reader :product

    def initialize(sku)
      @product = product
    end
  end
end
