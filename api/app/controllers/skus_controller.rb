class SkusController < ApplicationController
  def index
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_exporter(:csv) }
      format.xlsx { render_exporter(:xlsx) }
    end
  end

  def create
    sku = Sku::Generator.new.generate(sku_create_attrs)
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  def duplicate
    sku = Sku::Duplicator.new.duplicate(params[:sku])
    render json: sku.as_json_with_vendor_category_and_barcodes
  rescue ActiveRecord::RecordNotFound
    sku_code = params.try(:[], :sku).try(:[], :sku)
    return render json: { message: "Unable to find SKU #{sku_code}" }, status: 404
  rescue Exceptions::SkuDuplicationError => e
    return render json: { message: e.message }, status: 422
  end

  def show
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  def update
    Sku::Updator.update(sku, sku_update_attrs)
    render json: sku.as_json_with_vendor_category_and_barcodes
  rescue Exceptions::SkuUpdateError => e
    return render json: { message: e.message }, status: 422
  end

  def supplier_summary
    respond_to do |format|
      format.csv { render csv: supplier_summary_export }
      format.xlsx { render xlsx: supplier_summary_export }
    end
  end

  private

  def sku
    Sku.find(params[:id])
  end

  def sku_create_attrs
    params.permit(:sku, :product_id, :language_product_id,
                  :element_id, :option_id, :category_id, :internal_sku,
                  :category_name,
                  :manufacturer_sku, :lead_gender, :listing_genders, :vendor_id,
                  :product_name,
                  :manufacturer_color,
                  :manufacturer_size,
                  :season, :color, :size, :color_family, :size_scale,
                  :cost_price, :list_price, :price, :barcode, :inv_track,
                  :order_tool_reference)
  end

  def sku_update_attrs
    params.require(:sku).permit(:manufacturer_size, :cost_price, barcodes_attributes: [:barcode])
  end

  def render_index_json
    skus = Sku::Search.new.search(params)

    render json: { skus: skus.map(&:as_json_with_vendor_category_and_barcodes),
                   total_pages: skus.total_pages,
                   page: params[:page] || 1 },
           callback: params[:callback]
  rescue Exceptions::InvalidSearchFilters => e
    render json: { message: e.message }, status: 422
  end

  def render_exporter(format)
    render format => Sku::DataExporter.new.export(params)
  end

  def supplier_summary_export
    Sku::SupplierSummaryExporter.new.export(params)
  end
end
