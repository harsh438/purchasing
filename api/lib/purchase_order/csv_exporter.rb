class PurchaseOrder::CsvExporter
  def export(attrs)
    po = PurchaseOrder.find(attrs[:id])
    line_items_csv(po).tap do |csv|
      csv.unshift([order_number(po), '', delivery_date(po)], [])
      csv.push(['', '', '', '', '', '', 'TOTALS', po.quantity, '', '', po.total, '', ''])
    end
  end

  private

  def columns
    %w(barcode
       surfdome_sku
       item_code
       brand_color_code
       brand_product_name
       brand_color_name
       brand_size
       quantity
       supplier_list_price
       discounted_cost
       total)
  end

  def line_items_csv(po)
    PurchaseOrderLineItem::CsvExporter.new.export(po_number: po.id, columns: columns)
  end

  def order_number(po)
    "Order Number: SD#{po.id}-#{po.order_type}"
  end

  def delivery_date(po)
    "Delivery Date: #{po.drop_date}"
  end
end
