class PurchaseOrder::CsvExporter
  class NoFiltersError < RuntimeError; end

  def export(attrs)
    raise NoFiltersError unless searcher(attrs).filters.has_filters?
    searcher(attrs).unpaginated_results
  end

  private

  def searcher(attrs)
    ::Search.new(PurchaseOrder.with_summary, attrs)
  end
end
