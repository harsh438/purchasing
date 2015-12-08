class SkusController < ApplicationController
  def index
    render json: Sku.page(params[:page])
  end

  def create
    new_sku = Sku::Generator.new.sku_from!(sku_attrs)
    render json: new_sku.as_json
  end

  def show
    render json: sku.try(:as_json)
  end

  def update
    sku.update!(sku_attrs)
    render json: sku.try(:as_json)
  end

  private

  def sku
    @sku ||= Sku.find(params[:id])
  end

  def sku_attrs
    params
      .require(:sku)
      .permit(:sku,
              :product_id,
              :language_product_id,
              :element_id,
              :option_id,
              :category_id,
              :manufacturer_sku,
              :lead_gender,
              :vendor_id,
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
              :price,
              barcodes_attributes: [:barcode])
  end
end
