class PurchaseOrderLineItem::NegativeSkuPopulator
  def populate
    batched_po_line_items do |group|
      group.each do |po_line_item|
        found = true

        sku = Sku.find_or_create_by!(sku_attrs(po_line_item)) do
          found = false
        end

        sku.update!(sku_update_attrs(po_line_item))
        po_line_item.update!(sku: sku)

        record_result(po_line_item, sku, found)
      end
    end
  end

  private

  def batched_po_line_items(&block)
    po_line_items.find_in_batches.each(&block)
  end

  def po_line_items
    PurchaseOrderLineItem.where('pID < 0')
  end

  def sku_attrs(po_line_item)
    { sku: po_line_item.product_id,
      manufacturer_sku: po_line_item.product_sku,
      manufacturer_size: po_line_item.manufacturer_size,
      season: po_line_item.season }
  end

  def sku_update_attrs(po_line_item)
    { product_name: po_line_item.product_name,
      vendor_id: po_line_item.vendor_id,
      manufacturer_color: po_line_item.supplier_color_code,
      color: po_line_item.product_color,
      size: po_line_item.product_size,
      list_price: po_line_item.supplier_list_price,
      cost_price: po_line_item.cost,
      price: po_line_item.sell_price,
      category_id: language_category(po_line_item),
      gender: po_line_item.gender,
      inv_track: po_line_item.product_sized? ? 'O' : 'P' }
  end

  def language_category(po_line_item)
    LanguageCategory.english.find_by(category_id: po_line_item.category_id).try(:id)
  end

  def record_result(po_line_item, sku, found)
    puts "po_line_item: #{po_line_item.id}  sku_id: #{sku.id}  sku: #{sku.sku}  found: #{found}"
  end
end
