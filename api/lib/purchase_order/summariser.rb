class PurchaseOrder::Summariser
  include ActionView::Helpers::NumberHelper

  def summary(attrs)
    query = PurchaseOrderLineItem.mapped.with_valid_status.with_summary
    query = PurchaseOrderLineItem::Filter.new.filter(query, attrs)

    { summary: summary_values(query) }
  rescue PurchaseOrderLineItem::Filter::NoFiltersError
    { summary: {} }
  end

  private

  def summary_values(unpaged_results)
    ordered_quantity, ordered_cost, ordered_value = ordered_totals(unpaged_results)

    delivered_quantity, delivered_cost,
    balance_quantity, balance_cost = delivered_balance_totals(unpaged_results)

    cancelled_quantity, cancelled_cost = cancelled_totals(unpaged_results)

    joined_results = unpaged_results.joins('inner join ds_products p on purchase_orders.pID = p.pID')

    ordered_value = ordered_value(joined_results)
    delivered_value, balance_value = delivered_balance_values(joined_results)
    cancelled_value = cancelled_value(joined_results)

    { ordered_quantity: number_with_delimiter(ordered_quantity || 0),
      ordered_cost: monetize(ordered_cost),
      ordered_value: monetize(ordered_value),
      delivered_quantity: number_with_delimiter(delivered_quantity || 0),
      delivered_cost: monetize(delivered_cost),
      delivered_value: monetize(delivered_value),
      balance_quantity: number_with_delimiter((balance_quantity || 0) - (cancelled_quantity || 0)),
      balance_cost: monetize((balance_cost || 0) - (cancelled_cost || 0)),
      balance_value: monetize((balance_value || 0) - (cancelled_value || 0)),
      cancelled_quantity: number_with_delimiter(cancelled_quantity || 0),
      cancelled_cost: monetize(cancelled_cost),
      cancelled_value: monetize(cancelled_value) }
  end

  def ordered_totals(unpaged_results)
    unpaged_results.pluck('sum(qty) as ordered_quantity,
                           sum(qty * cost) as ordered_cost')
                   .flatten
  end

  def delivered_balance_totals(unpaged_results)
    unpaged_results.pluck('sum((qtyDone + qtyAdded)) as delivered_quantity,
                           sum((qtyDone + qtyAdded) * cost) as delivered_cost,
                           sum(qty - (qtyDone + qtyAdded)) as balance_quantity,
                           (sum(qty * cost) - sum((qtyDone + qtyAdded) * cost)) as balance_cost')
                    .flatten
  end

  def cancelled_totals(unpaged_results)
    unpaged_results.where(status: -1)
                   .pluck('sum((qty - (qtyDone + qtyAdded))) as cancelled_quantity,
                           sum((qty - (qtyDone + qtyAdded)) * cost)')
                   .flatten
  end

  def ordered_value(joined_results)
    joined_results.pluck('sum(qty * p.pPrice) as ordered_value')
                  .flatten
                  .first
  end

  def delivered_balance_values(joined_results)
    joined_results.pluck('sum((qtyDone + qtyAdded) * p.pPrice) as delivered_value,
                         (sum(qty * p.pPrice) - sum((qtyDone + qtyAdded) * p.pPrice)) as balance_value')
                  .flatten
  end

  def cancelled_value(joined_results)
    joined_results.where(status: -1)
                  .pluck('sum((qty - (qtyDone + qtyAdded)) * p.pPrice)')
                  .flatten
                  .first
  end

  def monetize(figure)
    number_to_currency(figure || 0, unit: '£')
  end
end
