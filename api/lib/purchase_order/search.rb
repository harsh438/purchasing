class PurchaseOrder::Search
  def search(attrs, additional_data)
    filters = Filters.new(PurchaseOrder, attrs)

    results = filters.filter(PurchaseOrder.mapped.with_summary).page(attrs[:page])

    { summary: {},
      results: results,
      more_results_available: !results.last_page?,
      page: attrs[:page],
      exportable: {} }.tap do |data|
      if filters.has_filters?(PurchaseOrder.mapped.with_summary)
        if results.total_pages > 10
          data[:exportable][:massive] = true
        else
          data[:exportable][:url] = additional_data[:export_url]
        end
      end
    end
  end
end
