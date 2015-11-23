class SkusController < ApplicationController
  def index
    render json: Sku.page(params[:page])
  end

  def create
    sku = Sku.generate_from!(sku_attrs)
    render json: sku.as_json
  end

  def show
    render json: Sku.find(params[:id]).try(:as_json)
  end

  private

  def sku_attrs
    params.permit([:product_id,
                   :element_id,
                   :manufacturer_sku,
                   :season])
  end
end
