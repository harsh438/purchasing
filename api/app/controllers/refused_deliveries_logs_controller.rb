class RefusedDeliveriesLogsController < ApplicationController
  def index
    render json: as_json
  end

  def create
    render json: RefusedDeliveriesLog.create!(refused_delivery_attrs)
  end

  private

  def refused_delivery_attrs
    refused_delivery_params = params.require(:refused_deliveries_log)
    refused_delivery_params.permit(:delivery_date,
                                   :courier,
                                   :brand_id,
                                   :pallets,
                                   :boxes,
                                   :info,
                                   :refusal_reason)
  end

  def as_json
    date_from, date_to = date_range
    refused_deliveries = RefusedDeliveriesLog.includes(:vendor)
                                             .where(delivery_date: date_from..date_to)
                                             .map(&:as_json_with_vendor_name)
  end

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
