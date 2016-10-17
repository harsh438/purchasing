class Sku::UnsizedMissingAttributes
  ATTRS_FROM_LINE_ITEM = {
    id: :sku_id,
    manufacturer_sku: :product_sku,
    product_id: :product_id,
    manufacturer_color: :product_color,
    cost_price: :supplier_list_price,
    list_price: :product_rrp,
    price: :sell_price,
    category_id: :category_id,
    product_name: :product_name,
    gender: :gender,
    vendor_id: :vendor_id,
    category_name: :category,
    sent_in_peoplevox: :sent_to_peoplevox,
    order_tool_reference: :order_tool_reference
  }

  ATTRS_FROM_PRODUCT = {
    sku: :sku,
    color: :color,
    inv_track: :inv_track,
    season: :season,
    on_sale: :on_sale,
    listing_genders: :listing_genders,
    language_product_id: :language_product_id

  }

  def initialize(missing_sku_id)
    @missing_sku_id = missing_sku_id
    @po_line_item = PurchaseOrderLineItem.find_by(sku_id: missing_sku_id)
  end

  def retrieve_attributes
    raise ArgumentError, 'Sku is not missing' if sku_not_missing?
    attrs_from_po_line_item.merge(attrs_from_product)
  end

  attr_reader :po_line_item, :missing_sku_id

  private

  def sku_not_missing?
    sku = Sku.find_by(id: missing_sku_id)
    sku.present? || (sku.blank? && po_line_item.blank?)
  end

  def product
    @product ||= Product.find_by(id: po_line_item.product_id)
  end

  def attrs_from_po_line_item
    ATTRS_FROM_LINE_ITEM.each_with_object({}) do |(key, value), built_attrs|
      built_attrs[key] = po_line_item.send(value)
    end
  end

  def attrs_from_product
    ATTRS_FROM_PRODUCT.each_with_object({}) do |(key, value), built_attrs|
      built_attrs[key] = send(value)
    end
  end

  def sku
    product.id.to_s
  end

  def color
    product.color
  end

  def inv_track
    'P'
  end

  def season
    @season ||= Season.find_by(nickname: po_line_item.season)
  end

  def on_sale
    product.on_sale
  end

  def listing_genders
    product.listing_genders
  end

  def language_product_id
    product.language_products.first.id
  end
end
