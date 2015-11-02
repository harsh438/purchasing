class PurchaseOrder::Search
  def search(attrs)
    results = Filters.new(PurchaseOrder, attrs)
      .filter(PurchaseOrder.mapped.with_summary)
      .page(attrs[:page])

    { summary: {},
      results: results,
      more_results_available: !results.last_page?,
      page: attrs[:page] }
  end
end
