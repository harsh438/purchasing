class PurchaseOrder::HubExporter
  DEFAULT_PURCHASE_ORDERS = 10
  MAX_PURCHASE_ORDERS = 60

  def export(params)
    hub_object(params.fetch(:request_id), params.fetch(:parameters))
  end

  private

  def hub_object(request_id, request_params)
    last_timestamp = request_params.fetch(:last_timestamp, nil)
    last_id = request_params.fetch(:last_id, 0)
    limit = safe_limit(request_params)

    purchase_orders = exportable_purchase_orders(last_timestamp, last_id, limit)

    { request_id: request_id,
      summary: "Returned #{purchase_orders.size} purchase orders objects.",
      purchase_orders: serialized_purchase_orders(purchase_orders),
      parameters: { last_timestamp: next_last_timestamp(purchase_orders, last_timestamp, limit),
                    last_id: purchase_orders.last.try(:id) } }
  end

  def safe_limit(request_params)
    if request_params[:limit].present?
      [request_params[:limit].to_i, MAX_PURCHASE_ORDERS].min
    else
      DEFAULT_PURCHASE_ORDERS
    end
  end

  def exportable_purchase_orders(last_timestamp, last_id, limit)
    PurchaseOrder.has_been_updated_since(last_timestamp, last_id)
                 .limit(limit)
                 .order(updated_at: :asc, id: :asc)
                 .booked_in
  end

  def next_last_timestamp(purchase_orders, last_timestamp, limit)
    if has_reached_end_of_purchase_orders?(purchase_orders, last_timestamp, limit)
      Time.now
    else
      purchase_orders.last.try(:updated_at)
    end
  end

  def has_reached_end_of_purchase_orders?(purchase_orders, last_timestamp, limit)
    (purchase_orders.count < limit and last_timestamp.nil?) or purchase_orders.empty?
  end

  def serialized_purchase_orders(purchase_orders)
    ActiveModel::ArraySerializer.new(purchase_orders,
                                     each_serializer: PurchaseOrderSerializer)
  end
end
