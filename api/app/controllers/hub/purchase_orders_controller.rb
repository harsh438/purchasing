class Hub::PurchaseOrdersController < ApplicationController
  def latest
    timestamp_from = params[:parameters][:timestamp_from]
    render json: PurchaseOrder.where('drop_date > ?', Time.parse(timestamp_from))
                              .includes_line_items
                              .map(&:as_json_with_line_items)
  end
end
