class PurchaseOrdersController < ApplicationController
  def index
    render json: PurchaseOrder::Summariser.new.summary(params)
  end

  def cancel
    orders = PurchaseOrderLineItem.where('LENGTH(po_number) > 0').where(po_number: params[:id])
    orders.each(&:cancel)
    render json: orders
  end
end
