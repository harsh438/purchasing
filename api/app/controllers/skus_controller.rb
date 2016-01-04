class SkusController < ApplicationController
  def index
    skus = Sku.latest.includes(:vendor, :language_category).page(params[:page])
    render json: { skus: skus.map(&:as_json_with_vendor_and_category),
                   total_pages: skus.total_pages,
                   page: params[:page] || 1 }
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
    params.permit(:sku, :product_id, :language_product_id,
                  :element_id, :option_id, :category_id,
                  :manufacturer_sku, :lead_gender, :vendor_id,
                  :product_name, :manufacturer_color, :manufacturer_size,
                  :season, :color, :size, :color_family, :size_scale,
                  :cost_price, :list_price, :price, :barcode)
  end
end
