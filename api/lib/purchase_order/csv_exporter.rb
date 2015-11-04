class PurchaseOrder::CsvExporter
  def export(attrs)
    query = PurchaseOrder.mapped.with_valid_status.with_summary
    PurchaseOrder::Filter.new.filter(query, attrs)
  end
end
