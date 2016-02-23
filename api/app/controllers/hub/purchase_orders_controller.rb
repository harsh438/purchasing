class Hub::PurchaseOrdersController < ApplicationController
  def latest
    request_id = params[:request_id]
    request_params = params[:parameters]

    limit = default_param(request_params[:limit], 10)
    # otherwise this will destroy the server because there is too much queries
    limit = 60 if limit.to_i > 60
    last_timestamp = default_param(request_params[:last_timestamp], nil)
    last_id = default_param(request_params[:last_id], 0)

    results = PurchaseOrder.has_been_updated_since(last_timestamp, last_id)
                           .with_barcodes
                           .without_negative_pids
                           .booked_in
                           .order(updated_at: :asc, id: :asc)
                           .limit(limit)
                           .includes_line_items

    render json: create_hub_object(results, request_id, last_timestamp, limit)
  end

  private

  def get_new_timestamp(results, last_timestamp, limit)
    new_timestamp = results.last.try(:updated_at)
    if (results.count < limit.to_i and last_timestamp.nil?) or results.count === 0
      new_timestamp = Time.new
    end
    new_timestamp
  end

  def create_hub_object(purchase_orders, request_id, last_timestamp, limit)
    {
      request_id: request_id,
      summary: "Returned #{purchase_orders.size} purchase orders objects.",
      purchase_orders: ActiveModel::ArraySerializer.new(
        purchase_orders,
        each_serializer: PurchaseOrderSerializer
      ),
      parameters: {
        last_timestamp: get_new_timestamp(purchase_orders, last_timestamp, limit),
        last_id: purchase_orders.last.try(:id)
      }
    }
  end

  private

  def default_param(param, default_val)
    param.present? ? param : default_val
  end
end
