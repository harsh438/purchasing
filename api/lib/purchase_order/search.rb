class PurchaseOrder::Search
  include ActionView::Helpers::NumberHelper

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

  def monetize(figure)
    number_to_currency(figure, unit: '£')
  end

  def summarize(results)
    { ordered_quantity: results.map { |r| r.quantity }.compact.sum.to_s,
      ordered_cost: monetize(results.map { |r| r.ordered_cost }.compact.sum),
      ordered_value: monetize(results.map { |r| r.ordered_value }.compact.sum),
      delivered_quantity: results.map { |r| r.delivered_quantity }.compact.sum.to_s,
      delivered_cost: monetize(results.map { |r| r.delivered_cost }.compact.sum),
      delivered_value: monetize(results.map { |r| r.delivered_value }.compact.sum),
      cancelled_quantity: results.map { |r| r.cancelled_quantity }.compact.sum.to_s,
      cancelled_cost: monetize(results.map { |r| r.cancelled_cost }.compact.sum),
      cancelled_value: monetize(results.map { |r| r.cancelled_value }.compact.sum),
      balance_quantity: results.map { |r| r.balance_quantity }.compact.sum.to_s,
      balance_cost: monetize(results.map { |r| r.balance_cost }.compact.sum),
      balance_value: monetize(results.map { |r| r.balance_value }.compact.sum) }
  end
end
