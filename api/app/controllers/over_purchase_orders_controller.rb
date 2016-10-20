class OverPurchaseOrdersController < ApplicationController
  rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid,
    with: :handle_error
  rescue_from Order::SkuNotFound,
    with: :handle_sku_not_found

  def create
    over_delivery = OverDelivery::Generator.new(over_delivery_attrs).generate
    render json: over_delivery.map { |order| order.as_json(include: [:line_items, :exports]) }
  end

  private

  def over_delivery_attrs
    %i(sku quantity user_id grn po_numbers).each_with_object({}) do |attribute, hash|
      hash[attribute] = params.require(:over_po).require(attribute)
    end
  end

  def handle_error(e)
    render json: { summary: e.message }, status: 500
  end

  def handle_sku_not_found
    render json: { summary: "Internal SKU does not exist for any season: #{over_delivery_attrs[:sku]}" }
  end
end
