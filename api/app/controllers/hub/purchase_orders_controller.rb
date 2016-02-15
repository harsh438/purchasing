class Hub::PurchaseOrdersController < ApplicationController
  def latest
    timestamp_from = params[:parameters][:timestamp_from]
    limit = params[:parameters][:limit] || 10
    request_id = params[:request_id]
    results = PurchaseOrder.where('po_summary.drop_date > ?', Time.parse(timestamp_from))
                           .not_sent_in_peoplevox
                           .with_barcodes
                           .booked_in
                           .limit(limit)
                           .includes_line_items

    render json: {
      request_id: request_id,
      purchase_orders: ActiveModel::ArraySerializer.new(
        results,
        each_serializer: PurchaseOrderSerializer
      )
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
end
