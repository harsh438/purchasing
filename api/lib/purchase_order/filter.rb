class PurchaseOrder::Filter
  class NoFiltersError < RuntimeError; end

  def filter(query, attrs)
    filters = Filters.new(PurchaseOrder, attrs)
    raise NoFiltersError unless filters.has_filters?(query)
    filters.filter(query)
  end
end
