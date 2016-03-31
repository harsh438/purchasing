class PurchaseOrderChunkSerializer
  def self.serialize(purchase_order, line_items, start_id)
    {
      id: "#{purchase_order.po_number}_#{line_items.first.po_chunk_number}",
      supplier_name: purchase_order.vendor_name,
      supplier_id: purchase_order.vendor_id,
      po_number: purchase_order.po_number,
      items: serialize_line_items(line_items, start_id),
      updated_at: purchase_order.updated_at,
      created_at: purchase_order.created_at
    }
  end

  private

  def self.serialize_line_items(line_items, start_id)
    ActiveModel::ArraySerializer.new(line_items, each_serializer: PurchaseOrderLineItemSerializer)
      .as_json.map do |line_item|
        line_item[:number] = start_id
        start_id += 1
        line_item
      end
  end
end
