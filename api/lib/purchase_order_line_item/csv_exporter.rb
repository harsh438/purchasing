class PurchaseOrderLineItem::CsvExporter
  CSV_COLUMN_ORDER = %w(product_barcode
                        po_number
                        order_type
                        product_id
                        product_sku
                        season
                        brand
                        category
                        gender
                        product_name
                        product_size
                        supplier_style_code
                        supplier_color_code
                        supplier_product_name
                        supplier_color_name
                        brand_size
                        product_cost
                        status
                        order_id
                        ordered_quantity
                        ordered_cost
                        ordered_value
                        delivery_date
                        order_first_received
                        delivered_quantity
                        delivered_cost
                        delivered_value
                        cancelled_quantity
                        cancelled_cost
                        cancelled_value
                        balance_quantity
                        balance_cost
                        balance_value
                        operator
                        weeks_on_sale
                        closing_date
                        comment)

  def export(attrs)
    query = PurchaseOrderLineItem.mapped.with_valid_status.with_summary
    query = PurchaseOrderLineItem::Filter.new.filter(query, attrs)
    to_csv(query)
  end

  private

  def to_csv(query)
    CSV.generate do |csv|
      csv << CSV_COLUMN_ORDER.map(&:humanize)

      query.each do |purchase_order|
        csv << row_data(purchase_order)
      end
    end
  end

  def row_data(purchase_order)
    data = purchase_order.as_json(unit: '')
    data.values_at(*CSV_COLUMN_ORDER)
  end
end
