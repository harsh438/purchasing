class OrdersController < ApplicationController
  def index
    orders = Order.latest.includes(:line_items, :exports).page(params[:page])
    render json: { orders: orders.as_json(include: [:line_items, :exports]),
                   total_pages: orders.total_pages,
                   page: params[:page] || 1 }
  end

  def create
    order = Order.create!(order_attrs)
    render json: order.as_json_with_line_items_and_purchase_orders
  end

  def show
    render json: order.as_json_with_line_items_and_purchase_orders
  end

  def update
    order.update!(order_line_item_attrs)
    render json: order.as_json_with_line_items_and_purchase_orders
  rescue OrderLineItem::PurchaseOrderNotFound => e
    render json: { errors: ['Internal SKU was not recognised'] }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }
  end

  def export
    orders = Order.where(id: params[:id]).includes(:line_items, :exports)
    Order::Exporter.new.export(orders, export_attrs.to_h)
    render json: orders.reload.map { |order| order.as_json(include: [:line_items, :exports]) }
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end

  def export_attrs
    params.permit(:single_line_id, :operator, :id, :format)
  end

  def order_attrs
    params.require(:order).permit(:name, :order_type)
  end

  def order_line_item_attrs
    params.require(:order).permit(line_items_attributes: [:internal_sku,
                                                          :cost,
                                                          :quantity,
                                                          :discount,
                                                          :drop_date])
  end
end
