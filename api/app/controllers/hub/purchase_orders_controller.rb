class Hub::PurchaseOrdersController < ApplicationController
  def latest
    timestamp_from = params[:parameters][:timestamp_from]
    limit = params[:parameters][:limit] || 10
    request_id = params[:request_id]
    results = PurchaseOrder.where('drop_date > ?', Time.parse(timestamp_from))
                           .includes_line_items
                           .limit(limit)
    render json: {
      request_id: request_id,
      purchase_orders: ActiveModel::ArraySerializer.new(
        results,
        each_serializer: PurchaseOrderSerializer
      )
    }
  end
end
