class PurchaseOrdersController < ApplicationController
  before_action :load_purchase_orders

  def index
    render json: @purchase_orders
  end

  private

  def load_purchase_orders
    @purchase_orders = PurchaseOrder.page(params[:page])
  end
end
