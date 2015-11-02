class PurchaseOrder::CsvExporter
  class NoFiltersError < RuntimeError; end

  def export(attrs)
    filters = Filters.new(PurchaseOrder, attrs)
    raise NoFiltersError unless filters.has_filters?
    filters.filter(PurchaseOrder.mapped.with_summary)
  end
end
