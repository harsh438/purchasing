class PurchaseOrder::Search
  def search(attrs, additional_data)
    query = PurchaseOrder.mapped.with_valid_status.with_summary
    query, has_filters = apply_filters(query, attrs)
    paginated_query = paginate_query(query, attrs)
    response = build_response(paginated_query, attrs)

    if has_filters
      enrich_response(response, query, additional_data)
    end

    response
  end

  private

  def apply_filters(query, attrs)
    [PurchaseOrder::Filter.new.filter(query, attrs), true]
  rescue PurchaseOrder::Filter::NoFiltersError
    [query, false]
  end

  def paginate_query(query, attrs)
    query.page(attrs[:page])
  end

  def build_response(results, attrs)
    { summary: {},
      results: results.index_by(&:id),
      drop_numbers: PurchaseOrder::DropNumbers.new.calculate(results),
      more_results_available: !results.last_page?,
      total_count: results.total_count,
      total_pages: results.total_pages,
      page: attrs[:page] || 1,
      exportable: {} }
  end

  def enrich_response(response, unpaged_results, additional_data)
    response[:summary] = PurchaseOrder::SummaryBuilder.new.build(unpaged_results)

    if response[:results].total_pages > 20
      response[:exportable][:massive] = true
    else
      response[:exportable][:url] = additional_data[:export_url]
    end
  end
end
