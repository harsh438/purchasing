class PurchaseOrderLineItem::Search
  def search(attrs, additional_data)
    query = PurchaseOrderLineItem.mapped.with_valid_status.with_summary
    query, has_filters = apply_filters(query, attrs)
    paginated_query = paginate_query(query, attrs)
    response = build_response(paginated_query, attrs)

    if has_filters
      enrich_response(response, additional_data)
    end

    response
  end

  private

  def apply_filters(query, attrs)
    [PurchaseOrderLineItem::Filter.new.filter(query, attrs), true]
  rescue PurchaseOrderLineItem::Filter::NoFiltersError
    [query, false]
  end

  def paginate_query(query, attrs)
    query.page(attrs[:page])
  end

  def build_response(results, attrs)
    { results: results,
      drop_numbers: PurchaseOrderLineItem::DropNumbers.new.calculate(results),
      more_results_available: !results.last_page?,
      total_count: results.total_count,
      total_pages: results.total_pages,
      page: attrs[:page] || 1,
      exportable: {} }
  end

  def enrich_response(response, additional_data)
    if response[:total_pages] > 20
      response[:exportable][:massive] = true
    else
      response[:exportable][:url] = additional_data[:export_url]
    end
  end
end
