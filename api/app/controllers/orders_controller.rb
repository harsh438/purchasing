class OrdersController < ApplicationController
  def index
    render json: Order.latest.includes(:exports).page(params[:page])
  end

  def create
    render json: Order.create!.as_json_with_line_items
  end

  def show
    render json: order.as_json_with_line_items
  end

  def update
    order.update!(order_attrs)
    render json: order.as_json_with_line_items
  end

  def export
    orders = Order.where(id: params[:id]).includes(:line_items, :exports)
    Order::Exporter.new.export(orders)
    render json: orders.reload.map { |order| order.as_json_with_line_items(include: [:exports]) }
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
