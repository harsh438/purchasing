class PurchaseOrder::Search
  def search(attrs, additional_data)
    filters = Filters.new(PurchaseOrder, attrs)
    unpaged_results = filters.filter(PurchaseOrder.mapped.with_valid_status.with_summary)
    results = unpaged_results.page(attrs[:page])
    response = build_response(results, attrs)
    enrich_response_if_filters_applied(response, unpaged_results, filters, additional_data)
  end

  def build_response(results, attrs)
    { summary: {},
      results: results,
      drop_numbers: PurchaseOrder::DropNumbers.new.calculate(results),
      more_results_available: !results.last_page?,
      total_count: results.total_count,
      total_pages: results.total_pages,
      page: attrs[:page] || 1,
      exportable: {} }
  end

  def enrich_response_if_filters_applied(response, unpaged_results, filters, additional_data)
    if filters.has_filters?(PurchaseOrder.mapped.with_summary)
      response[:summary] = PurchaseOrder::SummaryBuilder.new.build(unpaged_results)

      if response[:results].total_pages > 20
        response[:exportable][:massive] = true
      else
        response[:exportable][:url] = additional_data[:export_url]
      end
    end

    response
  end
end
