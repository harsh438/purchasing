class OrderLineItemsController < ApplicationController
  def destroy
    OrderLineItem.delete(params[:id])
    render json: params[:id]
  end
end
