class Hub::PurchaseOrdersController < ApplicationController
  def latest
    timestamp_from = params[:parameters][:timestamp_from]
    request_id = params[:parameters][:request_id]
    render json: {
      request_id: request_id,
      orders: PurchaseOrder.where('drop_date > ?', Time.parse(timestamp_from))
                           .includes_line_items
                           .limit(10)
                           .map(&:as_json_with_line_items)
    }
  end
end
