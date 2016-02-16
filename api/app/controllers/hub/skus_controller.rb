class Hub::SkusController < ApplicationController
  def latest
    request_id = params[:request_id]
    limit = 200
    if params[:parameters] and params[:parameters][:limit]
      limit = params[:parameters][:limit]
    end
    render json: {
      request_id: request_id,
      skus: ActiveModel::ArraySerializer.new(
        Sku.with_barcode.limit(10),
        each_serializer: SkuSerializer
      )
    }
  end
end
