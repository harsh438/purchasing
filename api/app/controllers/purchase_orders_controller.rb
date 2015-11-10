class PurchaseOrdersController < ApplicationController
  protect_from_forgery except: :cancel

  def index
    render json: PurchaseOrder::Summariser.new.summary(params)
  end

  def cancel
    orders = PurchaseOrderLineItem.where('LENGTH(po_number) > 0').where(po_number: params[:id])
    orders.each(&:cancel)
    render json: orders
  end

  def seasons
    render json: PurchaseOrderLineItem.seasons
  end

  def genders
    render json: PurchaseOrderLineItem.genders
  end

  def order_types
    render json: PurchaseOrderLineItem.order_types
  end
end
