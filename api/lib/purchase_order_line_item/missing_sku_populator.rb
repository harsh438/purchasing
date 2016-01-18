class PurchaseOrderLineItem::MissingSkuPopulator
  def populate
    purchase_order_line_items.each do |po_line_item|
      sku = Sku::Generator.new.generate(sku_attrs(po_line_item))
      po_line_item.update!(sku: sku)
      p "po_line_item=#{po_line_item.id}  sku_id=#{sku.id}"
    end
  end

  private

  def purchase_order_line_items
    valid_option = '(ds_options.oID IS NOT NULL AND LENGTH(purchase_orders.orderTool_brandSize) > 0)'
    no_option = 'purchase_orders.oID = 0'
    PurchaseOrderLineItem.joins(:product)
                         .joins(:option)
                         .where(sku_id: nil)
                         .where.not(ds_products: { pID: nil })
                         .where("#{valid_option} OR #{no_option}")
                         .where('LENGTH(purchase_orders.orderTool_SKU) > 0')
  end

  def sku_attrs(po_line_item)
    {}.merge(sku_manufacturer_attrs(po_line_item))
      .merge(sku_surfdome_attrs(po_line_item))
  end

  def sku_surfdome_attrs(po_line_item)
    { season: po_line_item.season,
      product_name: po_line_item.product_name,
      vendor_id: po_line_item.vendor_id,
      color: po_line_item.product_color,
      size: po_line_item.product_size,
      list_price: po_line_item.supplier_list_price,
      cost_price: po_line_item.cost,
      price: po_line_item.sell_price,
      category_id: language_category(po_line_item),
      lead_gender: po_line_item.gender,
      inv_track: inv_track(po_line_item),
      barcode: po_line_item.barcode }
  end

  def sku_manufacturer_attrs(po_line_item)
    { manufacturer_sku: po_line_item.product_sku,
      manufacturer_size: po_line_item.manufacturer_size,
      manufacturer_color: po_line_item.supplier_color_code }
  end

  def language_category(po_line_item)
    LanguageCategory.english.find_by(category_id: po_line_item.category_id).try(:id)
  end

  def inv_track(po_line_item)
    po_line_item.product_sized? ? 'O' : 'P'
  end
end
