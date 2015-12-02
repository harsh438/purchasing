class SkusController < ApplicationController
  def index
    render json: Sku.page(params[:page])
  end

  def create
    sku = Sku::Generator.new.sku_from!(sku_attrs)
    render json: sku.as_json
  end

  def show
    render json: Sku.find(params[:id]).try(:as_json)
  end

  private

  def sku_attrs
    params.permit([:manufacturer_sku,
                   :lead_gender,
                   :vendor_id,
                   :supplier_id,
                   :product_name,
                   :manufacturer_color,
                   :manufacturer_size,
                   :season,
                   :color,
                   :size,
                   :color_family,
                   :size_scale,
                   :cost_price,
                   :list_price,
                   :price])
  end
end
