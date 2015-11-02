class PurchaseOrder::CsvExporter
  class NoFiltersError < RuntimeError; end

  def export(attrs)
    filters = Filters.new(PurchaseOrder, attrs)
    collection = PurchaseOrder.mapped.with_summary
    raise NoFiltersError unless filters.has_filters?(collection)
    filters.filter(collection)
  end
end
