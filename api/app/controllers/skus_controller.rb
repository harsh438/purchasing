class SkusController < ApplicationController
  def index
    skus = Sku::Search.new.search(params)
    render json: { skus: skus.map(&:as_json_with_vendor_category_and_barcodes),
                   total_pages: skus.total_pages,
                   page: params[:page] || 1 }
  end

  def create
    sku = Sku::Generator.new.generate(sku_create_attrs)
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  def show
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  def update
    sku.update!(sku_update_attrs)
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  private

  def sku
    Sku.find(params[:id])
  end

  def sku_create_attrs
    params.permit(:sku, :product_id, :language_product_id,
                  :element_id, :option_id, :category_id,
                  :manufacturer_sku, :lead_gender, :vendor_id,
                  :product_name, :manufacturer_color, :manufacturer_size,
                  :season, :color, :size, :color_family, :size_scale,
                  :cost_price, :list_price, :price, :barcode)
  end

  def sku_update_attrs
    params.require(:sku).permit(:cost_price, barcodes_attributes: [:barcode])
  end
end
