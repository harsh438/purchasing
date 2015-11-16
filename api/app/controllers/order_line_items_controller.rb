class OrderLineItemsController < ApplicationController
  def destroy
    OrderLineItem.delete(params[:id])
    render json: [params[:id]]
  end

  def update
    order_line_item.update!(line_item_attrs)
    render json: order_line_item.order.as_json_with_line_items_and_purchase_orders
  end

  private

  def line_item_attrs
    params.require(:order_line_item).permit([:cost, :discount, :quantity])
  end

  def order_line_item
    @order_line_item ||= OrderLineItem.find(params[:id])
  end
end
