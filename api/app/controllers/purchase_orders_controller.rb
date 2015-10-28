class PurchaseOrdersController < ApplicationController
  def index
    render json: PurchaseOrder.first(10)
  end
end
