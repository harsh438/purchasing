class OrdersController < ApplicationController
  def index
    orders = Order.latest.where(filter_params).includes(:line_items, :exports).page(params[:page])
    render json: { orders: orders.as_json(include: [:line_items, :exports]),
                   total_pages: orders.total_pages,
                   page: params[:page] || 1 }
  end

  def create
    order = Order.create!(order_attrs)
    render json: order.as_json_with_line_items_and_purchase_orders.merge!(url: order_url_for(order))
  end

  def show
    render json: order.as_json_with_line_items_and_purchase_orders
  end

  def update
    Order::LineItemAdder.new.add(order, order_line_item_attrs[:line_items_attributes])
    render json: order.as_json_with_line_items_and_purchase_orders
  rescue OrderLineItem::SkuNotFound => e
    Rails.logger.debug("Internal SKU was not recognised: #{e.sku}")
    render json: { errors: ["Internal SKU was not recognised: #{e.sku}"] }
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.debug("ActiveRecord::RecordInvalid in OrdersController: #{e.record}")
    render json: { errors: e.record.errors.full_messages }
  end

  def export
    orders = Order.where(id: params[:id]).includes(:line_items, :exports)
    Order::Exporter.new.export(orders, export_attrs.to_h)
    render json: orders.reload.map { |order| order.as_json(include: [:line_items, :exports]) }
  end

  private

  def order_url_for(order)
    url = url_for(order)
    url.sub('/api/', '/#/').sub('.json', '/edit')
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def filter_params
    params.permit(filters: [:order_type])[:filters]
  end

  def export_attrs
    params.permit(:single_line_id, :operator, :id, :format)
  end

  def order_attrs
    params.require(:order).permit(:name, :order_type)
  end

  def order_line_item_attrs
    params.require(:order).permit(line_items_attributes: [:internal_sku,
                                                          :manufacturer_size,
                                                          :season,
                                                          :cost,
                                                          :quantity,
                                                          :discount,
                                                          :drop_date])
  end
end
