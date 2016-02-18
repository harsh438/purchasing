class Hub::SkusController < ApplicationController
  def latest
    request_id = params[:request_id]
    request_params = params[:parameters]

    limit = default_param(request_params[:limit], 200)
    last_timestamp = default_param(request_params[:last_timestamp], Time.now)
    last_id = default_param(request_params[:last_id], 0)

    results = Sku.includes(:language_category)
              .where('(skus.updated_at >= ? or skus.updated_at is null) and skus.id > ?', last_timestamp, last_id)
              .with_barcode
              .order(updated_at: :asc, id: :asc)
              .limit(limit)
    render json: {
      request_id: request_id,
      summary: "Returned #{results.size} sku objects.",
      skus: ActiveModel::ArraySerializer.new(
        results,
        each_serializer: SkuSerializer
      ),
      parameters: {
        last_timestamp: results.last.try(:updated_at) || last_timestamp,
        last_id: results.last.try(:id) || last_id
      }
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

  private

  def default_param(param, default_val)
    param.present? ? param : default_val
  end
end
