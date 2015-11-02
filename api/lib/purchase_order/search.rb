class PurchaseOrder::Search
  def search(attrs)
    { summary: {},
      results: searcher(attrs).results,
      more_results_available: !searcher(attrs).results.last_page?,
      page: attrs[:page] }
  end

  private

  def searcher(attrs)
    ::Search.new(PurchaseOrder.with_summary, attrs)
  end
end
