class RefusedDeliveriesLogsController < ApplicationController
  def index
    render json: as_json
  end

  def create
    render json: RefusedDeliveriesLog.create!(refused_delivery_attrs)
  end

  def update
    refused_delivery_log.update!(refused_delivery_attrs)
    render json: refused_delivery_log.as_json_with_images
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
                                   :refusal_reason,
                                   refused_deliveries_log_images_attributes: image_attrs)
  end

  def image_attrs
    [:id, :image, :image_file_name]
  end

  def refused_delivery_log
    RefusedDeliveriesLog.find(params[:id])
  end

  def as_json
    date_from, date_to = date_range
    refused_deliveries = RefusedDeliveriesLog.includes(:vendor)
                                             .includes(:refused_deliveries_log_images)
                                             .where(delivery_date: date_from..date_to)
                                             .map(&:as_json_with_vendor_name_and_images)
  end

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
