class PurchaseOrdersController < ApplicationController
  before_action :load_purchase_orders

  def index
    render json: @purchase_orders
  end

  def seasons
    render json: PurchaseOrder.seasons
  end

  private

  def load_purchase_orders
    @purchase_orders = filter_purchase_orders
  end

  def filter_purchase_orders
    @purchase_orders = Search.new(PurchaseOrder, params).results
  end
end
