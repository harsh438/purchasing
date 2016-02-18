class Hub::PurchaseOrdersController < ApplicationController
  def latest
    request_id = params[:request_id]
    request_params = params[:parameters]

    limit = default_param(request_params[:limit], 10)
    last_timestamp = default_param(request_params[:last_timestamp], Time.now)
    last_id = default_param(request_params[:last_id], 0)

    results = PurchaseOrder.has_been_updated_since(last_timestamp, last_id)
                           .with_barcodes
                           .booked_in
                           .order(updated_at: :asc, id: :asc)
                           .limit(limit)
                           .includes_line_items

    render json: create_hub_object(results, request_id, last_timestamp, last_id)
  end

  def create_hub_object(purchase_orders, request_id, last_timestamp, last_id)
    {
      request_id: request_id,
      summary: "Returned #{purchase_orders.size} purchase orders objects.",
      purchase_orders: ActiveModel::ArraySerializer.new(
        purchase_orders,
        each_serializer: PurchaseOrderSerializer
      ),
      parameters: {
        last_timestamp: purchase_orders.last.try(:updated_at) || last_timestamp,
        last_id: purchase_orders.last.try(:id) || last_id
      }
    }
  end

  def pvx_confirm
    purchase_order_id = params[:purchase_order][:id]
    purchase_order = PurchaseOrder.includes(:line_items).find(purchase_order_id)
    purchase_order.line_items.each do |line_item|
      line_item.sent_to_peoplevox = 1
      line_item.save
    end
    message = "PurchaseOrder #{purchase_order_id} has been marked as sent to PeopleVox and won't be processed again."
    render json: { message: message }
  end

  private

  def default_param(param, default_val)
    param.present? ? param : default_val
  end
end
