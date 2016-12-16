class OverPurchaseOrdersController < ApplicationController
  rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid,
    OverDelivery::Generator::MissingItemsForCost,
    with: :handle_error
  rescue_from Order::SkuNotFound, OverDelivery::Generator::SkuNotFoundForSeason,
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
    log('error', e)
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
      attrs = OverDelivery::NewSkuAttributes.new(old_sku, season).build
      log('attrs', attrs)
      sku = Sku::Generator.new.generate(attrs)
      log('sku', sku)
      create
    rescue ActiveRecord::RecordNotFound => e
      handle_error(e)
    end
  end

  def log(data_type, data)
    Rails.application.config.logger.info(
      status: 'DONE',
      log_type: 'generate_sku_from_over_po',
      data_type: data_type,
      data: data
    )
  end
end
