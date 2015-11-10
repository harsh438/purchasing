class PurchaseOrdersController < ApplicationController
  protect_from_forgery except: :cancel

  def index
    render json: PurchaseOrder::SummaryBuilder.new.build(params)
  end

  def cancel
    orders = PurchaseOrder.where('LENGTH(po_number) > 0').where(po_number: params[:id])
    orders.each(&:cancel)
    render json: orders
  end

  def seasons
    render json: PurchaseOrder.seasons
  end

  def genders
    render json: PurchaseOrder.genders
  end

  def order_types
    render json: PurchaseOrder.order_types
  end
end
