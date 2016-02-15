class Hub::BrandsController < ApplicationController
  def latest
    request_id = params[:request_id]
    limit = 200
    if params[:parameters] and params[:parameters][:limit]
      limit = params[:parameters][:limit]
    end
    results = Vendor.limit(limit)
    render json: {
      request_id: request_id,
      brands: ActiveModel::ArraySerializer.new(
        results,
        each_serializer: ::BrandSerializer
      )
    }
  end
end
