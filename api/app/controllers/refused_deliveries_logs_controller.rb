class RefusedDeliveriesLogsController < ApplicationController
  def index
    render json: refused_deliveries
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

  def refused_deliveries
    date_from, date_to = date_range
    refused_deliveries = RefusedDeliveriesLog.includes(:refused_delivery_vendor)
                                             .where(delivery_date: date_from..date_to)

    refused_deliveries.map do |refused_delivery|
      {
        id: refused_delivery[:id],
        delivery_date: refused_delivery[:delivery_date],
        courier: refused_delivery[:courier],
        brand: refused_delivery.refused_delivery_vendor.try(:name),
        pallets: refused_delivery[:pallets],
        boxes: refused_delivery[:boxes],
        info: refused_delivery[:info],
        refusal_reason: refused_delivery[:refusal_reason]
      }
    end
  end

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
