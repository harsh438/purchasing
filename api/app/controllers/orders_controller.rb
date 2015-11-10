class OrdersController < ApplicationController
  def index
    render json: Order.latest.page(params[:page])
  end
end
