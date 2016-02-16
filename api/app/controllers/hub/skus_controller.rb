class Hub::SkusController < ApplicationController
  def latest
    request_id = params[:request_id]
    limit = 50
    if params[:parameters] and params[:parameters][:limit]
      limit = params[:parameters][:limit]
    end
    skus = Sku.includes(:language_category).not_sent_in_peoplevox.with_barcode.limit(limit)
    render json: {
      request_id: request_id,
      skus: ActiveModel::ArraySerializer.new(
        skus,
        each_serializer: SkuSerializer
      )
    }
  end

  def pvx_confirm
    sku_id = params[:sku][:id]
    sku = Sku.find(sku_id)
    sku.sent_in_peoplevox = DateTime.now
    sku.save!
    message = "Sku #{sku_id} has been marked as sent to PeopleVox and won't be processed again."
    render json: { message: message }
  end
end
