class OrdersController < ApplicationController
  def index
    results = Order.latest.includes(:exports).page(params[:page])
    render json: { orders: results,
                   total_pages: results.total_pages,
                   page: params[:page] || 1 }
  end

  def create
    render json: Order.create!.as_json_with_line_items_and_purchase_orders
  end

  def show
    render json: order.as_json_with_line_items_and_purchase_orders
  end

  def update
    begin
      order.update!(order_attrs)
      render json: order.as_json_with_line_items_and_purchase_orders
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: [e.to_s] }
    end
  end

  def export
    orders = Order.where(id: params[:id]).includes(:line_items, :exports)
    Order::Exporter.new.export(orders)
    render json: orders.reload.map { |order| order.as_json(include: [:line_items, :exports]) }
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
