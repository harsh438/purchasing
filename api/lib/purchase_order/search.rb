class PurchaseOrder::Search
  def search(attrs, additional_data)
    filters = Filters.new(PurchaseOrder, attrs)

    results = filters.filter(PurchaseOrder.mapped.with_summary).page(attrs[:page])

    { summary: {},
      results: results,
      more_results_available: !results.last_page?,
      total_count: results.total_count,
      total_pages: results.total_pages,
      page: attrs[:page],
      exportable: {} }.tap do |data|
      if filters.has_filters?(PurchaseOrder.mapped.with_summary)
        data[:summary] = summarize(results)

        if results.total_pages > 10
          data[:exportable][:massive] = true
        else
          data[:exportable][:url] = additional_data[:export_url]
        end
      end
    end
  end

  def summarize(results)
    { ordered_quantity: results.map { |r| r.ordered_quantity }.compact.sum,
      ordered_cost: results.map { |r| r.ordered_cost }.compact.sum,
      ordered_value: results.map { |r| r.ordered_value }.compact.sum,
      delivered_quantity: results.map { |r| r.delivered_quantity }.compact.sum,
      delivered_cost: results.map { |r| r.delivered_cost }.compact.sum,
      delivered_value: results.map { |r| r.delivered_value }.compact.sum,
      cancelled_quantity: results.map { |r| r.cancelled_quantity }.compact.sum,
      cancelled_cost: results.map { |r| r.cancelled_cost }.compact.sum,
      cancelled_value: results.map { |r| r.cancelled_value }.compact.sum,
      balance_quantity: results.map { |r| r.balance_quantity }.compact.sum,
      balance_cost: results.map { |r| r.balance_cost }.compact.sum,
      balance_value: results.map { |r| r.balance_value }.compact.sum }
  end
end
