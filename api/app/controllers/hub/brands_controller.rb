class Hub::BrandsController < ApplicationController
  def latest
    request_id = params[:request_id]
    request_params = params[:parameters]

    limit = default_param(request_params[:limit], 200)
    last_timestamp = default_param(request_params[:last_timestamp], nil)
    last_id = default_param(request_params[:last_id], 0)

    results = Vendor.updated_since(last_timestamp, last_id)
                    .order(updated_at: :asc, id: :asc)
                    .limit(limit)
    new_timestamp = results.last.try(:updated_at)
    new_timestamp = Time.new if (results.count < limit.to_i and last_timestamp.nil?) or results.count === 0

    render json: {
      request_id: request_id,
      summary: "Returned #{results.size} brand objects.",
      brands: ActiveModel::ArraySerializer.new(
        results,
        each_serializer: ::BrandSerializer
      ),
      parameters: {
        last_timestamp: new_timestamp,
        last_id: results.last.try(:id)
      }
    }
  end

  def pvx_confirm
    brand_id = params[:brand][:id]
    brand = Vendor.find(brand_id)
    brand.sent_in_peoplevox = DateTime.now
    brand.save!
    render json: { message: "Order #{brand_id} has now been marked as being sent in peoplevox" }
  end

  private

  def default_param(param, default_val)
    param.present? ? param : default_val
  end
end
