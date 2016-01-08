class PurchaseOrderLineItem::NegativeSkuPopulator
  def populate
    po_line_items.find_in_batches.each do |group|
      group.each do |po_line_item|
        found = true

        sku = Sku.find_or_create_by!(sku_attrs(po_line_item)) do
          found = false
        end

        po_line_item.update!(sku: sku)

        record_result(po_line_item, sku, found)
      end
    end
  end

  private

  def po_line_items
    PurchaseOrderLineItem.where('pID < 0').where(sku_id: nil)
  end

  def sku_attrs(po_line_item)
    { sku: po_line_item.product_id,
      manufacturer_sku: po_line_item.product_sku,
      season: po_line_item.season }
  end

  def record_result(po_line_item, sku, found)
    puts "po_line_item: #{po_line_item.id}  sku_id: #{sku.id}  sku: #{sku.sku}  found: #{found}"
  end
end
