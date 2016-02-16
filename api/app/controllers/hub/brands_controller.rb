class Hub::BrandsController < ApplicationController
  def latest
    request_id = params[:request_id]
    limit = 200
    if params[:parameters] and params[:parameters][:limit]
      limit = params[:parameters][:limit]
    end
    results = Vendor.not_sent_in_peoplevox.limit(limit)
    render json: {
      request_id: request_id,
      brands: ActiveModel::ArraySerializer.new(
        results,
        each_serializer: ::BrandSerializer
      )
    }
  end

  def pvx_confirm
    brand_id = params[:brand][:id]
    brand = Vendor.find(brand_id)
    brand.sent_in_peoplevox = DateTime.now
    brand.save!
    render json: { message: "Order #{brand_id} has now been marked as being sent in peoplevox" }
  end
end
