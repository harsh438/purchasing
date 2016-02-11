class PurchaseOrdersHubController < ApplicationController
  def index
    render json: PurchaseOrder.from_yesterday.includes_line_items.map(&:as_json_with_line_items)
  end
end
