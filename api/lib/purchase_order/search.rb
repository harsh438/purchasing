class PurchaseOrder::Search
  include ActionView::Helpers::NumberHelper

  def search(attrs, additional_data)
    filters = Filters.new(PurchaseOrder, attrs)
    unpaged_results = filters.filter(PurchaseOrder.mapped.with_valid_status.with_summary)
    results = unpaged_results.page(attrs[:page])



    { summary: {},
      results: results,
      drop_dates: drop_dates(results),
      more_results_available: !results.last_page?,
      total_count: results.total_count,
      total_pages: results.total_pages,
      page: attrs[:page] || 1,
      exportable: {} }.tap do |data|
      if filters.has_filters?(PurchaseOrder.mapped.with_summary)
        data[:summary] = summarize(unpaged_results)

        if results.total_pages > 20
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

  def summarize(unpaged_results)
    r = unpaged_results
          .joins('inner join ds_products p on purchase_orders.pID = p.pID')

    ordered_quantity, ordered_cost, ordered_value, delivered_quantity,
    delivered_cost, delivered_value, balance_quantity, balance_cost, balance_value =
      r.pluck('sum(qty) as ordered_quantity,
                 sum(qty * cost) as ordered_cost,
                 sum(qty * p.pPrice) as ordered_value,

                 sum((qtyDone + qtyAdded)) as delivered_quantity,
                 sum((qtyDone + qtyAdded) * cost) as delivered_cost,
                 sum((qtyDone + qtyAdded) * p.pPrice) as delivered_value,

                 sum(qty - (qtyDone + qtyAdded)) as balance_quantity,
                 (sum(qty * cost) - sum((qtyDone + qtyAdded) * cost)) as balance_cost,
                 (sum(qty * p.pPrice) - sum((qtyDone + qtyAdded) * p.pPrice)) as balance_value')
       .flatten

    cancelled_quantity, cancelled_cost, cancelled_value =
      r.where('status = -1')
       .pluck('sum((qty - (qtyDone + qtyAdded))) as cancelled_quantity,
               sum((qty - (qtyDone + qtyAdded)) * cost),
               sum((qty - (qtyDone + qtyAdded)) * p.pPrice)')
       .flatten

    { ordered_quantity: ordered_quantity,
      ordered_cost: monetize(ordered_cost),
      ordered_value: monetize(ordered_value),
      delivered_quantity: delivered_quantity,
      delivered_cost: monetize(delivered_cost),
      delivered_value: monetize(delivered_value),
      balance_quantity: balance_quantity,
      balance_cost: monetize(balance_cost),
      balance_value: monetize(balance_value),
      cancelled_quantity: cancelled_quantity,
      cancelled_cost: monetize(cancelled_cost),
      cancelled_value: monetize(cancelled_value) }
  end

  def drop_dates(results)
    criteria = results.reduce([]) do |criteria, purchase_order|
      if purchase_order.product_id > 0 and purchase_order.option_id > 0
        criteria << purchase_order.product_id
        criteria << purchase_order.option_id
      else
        criteria
      end
    end

    return [] unless criteria.count > 0

    query = (criteria.count / 2).times.map { '(pID = ? AND oID = ?)' }.join(' OR ')

    total_drops = PurchaseOrder.with_summary
                               .with_valid_status
                               .where(query, *criteria)
                               .group(:pID, :oID)
                               .count

    criteria = results.reduce([]) do |criteria, purchase_order|
      if purchase_order.product_id > 0 and purchase_order.option_id > 0
        criteria << purchase_order.product_id
        criteria << purchase_order.option_id
        criteria << purchase_order.drop_date
      else
        criteria
      end
    end

    query = (criteria.count / 3).times.map { '(pID = ? AND oID = ? AND drop_date < ?)' }.join(' OR ')

    drops_before = PurchaseOrder.with_summary
                                .with_valid_status
                                .where(query, *criteria)
                                .group(:drop_date, :pID, :oID)
                                .count

    drops = {}

    results.each do |purchase_order|
      drops_before_key = [purchase_order.delivery_date,
                          purchase_order.product_id,
                          purchase_order.option_id]

      total_drops_key = [purchase_order.product_id,
                         purchase_order.option_id]

      drops_before_value = (drops_before[drops_before_key] || 0) + 1

      drops[purchase_order.id] = "#{drops_before_value}/#{total_drops[total_drops_key]}"
    end

    drops
  end
end
