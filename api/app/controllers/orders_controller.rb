class OrdersController < ApplicationController
  def index
    render json: Order.latest.page(params[:page])
  end

  def create
    render json: Order.create!.as_json(include: :line_items)
  end

  def show
    render json: order.as_json(include: :line_items)
  end

  def update
    order.update!(order_attrs)
    render json: order.as_json(include: :line_items)
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end

  def order_attrs
    params.require(:order).permit(line_items_attributes: [:internal_sku,
                                                          :cost,
                                                          :quantity,
                                                          :discount,
                                                          :drop_date])
  end
end
