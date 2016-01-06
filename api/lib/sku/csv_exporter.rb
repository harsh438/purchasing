class Sku::CsvExporter
  def export(params)
    csv = Csv::ViewModel.new
    csv << columns

    if params[:order_id].present?
      order = Order.find(params[:order_id])
      csv.concat(skus_in_order(order))
    elsif params[:purchase_order_id].present?
      purchase_order = PurchaseOrder.find(params[:purchase_order_id])
      csv.concat(skus_in_purchase_order(purchase_order))
    end
  end

  private

  def columns
    [:internal_sku, :barcode]
  end

  def skus_in_order(order)
    order.purchase_orders.flat_map { |po| skus_in_purchase_order(po) }
  end

  def skus_in_purchase_order(po)
    po.line_items.map do |po_line_item|
      values_from_sku(Sku.find_by(sku: po_line_item.internal_sku))
    end.compact
  end

  def values_from_sku(sku)
    if sku.present?
      sku.attributes.values_at(columns.map(&:to_s))
    end
  end
end
