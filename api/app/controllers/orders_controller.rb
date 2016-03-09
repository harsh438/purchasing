class OrdersController < ApplicationController
  def index
    orders = orders_filtered.page(params[:page])
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
    Order::LineItemAdder.new.add(order, order_line_item_attrs)
    render json: order.as_json_with_line_items_and_purchase_orders
  rescue Order::SkuNotFound => e
    render json: { errors: build_non_existant_sku_errors }
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

  def build_non_existant_sku_errors
    errors = ["Internal SKU does not exist for season #{order.season}: #{nonexistant_skus_by_season(order)}"]
    unknown_skus = nonexistant_skus
    unless unknown_skus.empty?
      errors.push("Internal SKU does not exist for any season: #{unknown_skus}")
    end
    errors.each { |error| Rails.logger.debug(error) }
    errors
  end

  def order_url_for(order)
    url = url_for(order)
    url.sub('/api/', '/#/').sub('.json', '/edit')
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def orders_filtered
    filters = filter_params || {}
    query = Order.latest
    if filters[:order_type].present?
      query = query.where(order_type: filters[:order_type])
    end
    if filters[:name].present?
      query = query.where('UPPER(name) like ?', "%#{filters[:name].upcase}%")
    end
    query
  end

  def filter_params
    params.permit(filters: [:order_type, :name])[:filters]
  end

  def export_attrs
    params.permit(:single_line_id, :operator, :id, :format)
  end

  def order_attrs
    params.require(:order).permit(:name, :order_type, :season)
  end

  def order_line_item_attrs
    lines = params.require(:order).permit(line_items_attributes: [:internal_sku,
                                                                  :manufacturer_size,
                                                                  :season,
                                                                  :cost,
                                                                  :quantity,
                                                                  :discount,
                                                                  :drop_date])
    if lines[:line_items_attributes].is_a?(Hash)
      lines[:line_items_attributes].values
    else
      lines[:line_items_attributes] || []
    end
  end

  def nonexistant_skus_by_season(order)
    skus = order_line_item_attrs.map { |line_item| line_item[:internal_sku] }
    Sku.nonexistant_skus_with_season(skus, order.season).join(', ')
  end

  def nonexistant_skus
    skus = order_line_item_attrs.map { |line_item| line_item[:internal_sku] }
    Sku.nonexistant_skus(skus).join(', ')
  end
end
