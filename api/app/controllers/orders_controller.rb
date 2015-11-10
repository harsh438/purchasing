class OrdersController < ApplicationController
  def index
    render json: Order.latest.page(params[:page])
  end

  def show
    render json: Order.find(params[:id]).as_json(include: :line_items)
  end
end
