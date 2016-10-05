class Hub::ProductsController < ApplicationController

  def latest
    last_id, limit, last_ts = wombat_params.values_at(
      :last_imported_id, :import_size, :last_imported_timestamp,
    )

    last_ts = Time.zone.parse(last_ts) if last_ts.present?

    products = Product.pending_import(last_id, limit, last_ts)
    render json: create_hub_object(products, last_ts, last_id)
  end

  private

  def wombat_params
    params.require(:parameters).permit(
      :last_imported_id, :import_size, :last_imported_timestamp
    )
  end

  def create_hub_object(products, last_timestamp, last_id)
    {
      request_id: params[:request_id],
      summary: "Returned #{products.length} product objects.",
      log_type: "product",
      products: ActiveModel::ArraySerializer.new(
        products,
        each_serializer: ProductSerializer
      ),
      parameters: {
        last_imported_timestamp: products.last.try(:updated_at) || last_timestamp,
        last_imported_id: products.last.try(:id) || last_id
      }
    }
  end
end
