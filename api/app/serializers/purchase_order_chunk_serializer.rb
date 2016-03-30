class PurchaseOrderChunkSerializer
  def self.serialize(purchase_order, line_items)
    {
      id: "#{purchase_order.po_number}_#{line_items.first.po_chunk_number}",
      supplier_name: purchase_order.vendor_name,
      supplier_id: purchase_order.vendor_id,
      po_number: purchase_order.po_number,
      items: serialize_line_items(line_items),
      updated_at: purchase_order.updated_at,
      created_at: purchase_order.created_at
    }
  end

  private

  def self.serialize_line_items(line_items)
    ActiveModel::ArraySerializer.new(line_items,
                                     each_serializer: PurchaseOrderLineItemSerializer)
  end
end
