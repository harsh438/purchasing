class PurchaseOrderLineItem::Filter
  class NoFiltersError < RuntimeError; end

  def filter(query, attrs)
    filters = Generics::Filters.new(PurchaseOrderLineItem, attrs.merge(sort_by: order(attrs)))
    raise NoFiltersError unless filters.has_filters?(query)
    filters.filter(query)
  end

  private

  def order(attrs)
    case attrs[:sort_by]
    when 'drop_date_asc'
      { delivery_date: :asc,
        product_id: :asc,
        id: :asc }
    when 'product_id_desc'
      { product_id: :desc }
    when 'product_sku_desc'
      { product_sku: :desc }
    else
      { delivery_date: :asc,
        product_id: :asc,
        id: :asc }
    end
  end
end
