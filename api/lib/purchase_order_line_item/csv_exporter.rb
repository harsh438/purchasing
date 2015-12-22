class PurchaseOrderLineItem::CsvExporter
  CSV_DEFAULT_COLUMNS = %w(product_barcode
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
    columns = csv_columns(attrs[:columns] || {})
    csv = Csv::ViewModel.new
    csv << columns.map(&:humanize)
    csv.concat(query.map { |purchase_order| row_data(purchase_order, columns) })
  end

  private

  def row_data(purchase_order, columns)
    data = purchase_order.as_json(unit: '').with_indifferent_access
    data.values_at(*columns)
  end

  def csv_columns(columns)
    if columns.nil? or columns.length == 0
      CSV_DEFAULT_COLUMNS
    else
      columns
    end
  end
end
