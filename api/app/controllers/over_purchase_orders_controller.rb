class OverPurchaseOrdersController < ApplicationController
  rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid,
    with: :handle_error
  rescue_from Order::SkuNotFound,
    with: :sku_not_found

  def create
    over_delivery = OverDelivery::Generator.new(over_delivery_attrs).generate
    render json: over_delivery.map { |order| order.as_json(include: [:line_items, :exports]) }
  end

  private

  def over_delivery_attrs
    @attrs ||= %i(sku quantity user_id grn po_numbers).each_with_object({}) do |attribute, hash|
      hash[attribute] = params.require(:over_po).require(attribute)
    end
  end

  def handle_error(e)
    render json: { summary: e.message }, status: 500
  end

  def sku_not_found(e)
    sku, season = e.sku, e.season
    begin
      old_sku = Sku.find_by!(sku: sku)
      generate_sku_and_reprocess(old_sku, season)
    rescue ActiveRecord::RecordNotFound => e
      handle_error(e)
    end
  end

  def generate_sku_and_reprocess(old_sku, season)
    begin
      barcode = Barcode.find_by!(sku_id: old_sku.id).barcode
      attrs = new_sku_attrs(old_sku, barcode, season)
      Sku::Generator.new.generate(attrs)
      create
    rescue ActiveRecord::RecordNotFound => e
      handle_error(e)
    end
  end

  def new_sku_attrs(sku, barcode, season)
    attrs = sku.attributes
    attrs[:season] = season
    attrs[:barcode] = barcode
    attrs[:internal_sku] = attrs['sku']
    attrs
  end
end
