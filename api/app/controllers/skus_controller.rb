class SkusController < ApplicationController
  def index
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_index_csv }
    end
  end

  def create
    sku = Sku::Generator.new.generate(sku_create_attrs)
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  def show
    render json: sku.as_json_with_vendor_category_and_barcodes
  end

  def update
    ActiveRecord::Base.transaction do
      sku.update!(sku_update_attrs)
      Sku::Exporter.new.export(sku)
    end

    render json: sku.as_json_with_vendor_category_and_barcodes
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
                  :cost_price, :list_price, :price, :barcode, :inv_track)
  end

  def sku_update_attrs
    params.require(:sku).permit(:cost_price, barcodes_attributes: [:barcode])
  end

  def render_index_json
    skus = Sku::Search.new.search(params)

    render json: { skus: skus.map(&:as_json_with_vendor_category_and_barcodes),
                   total_pages: skus.total_pages,
                   page: params[:page] || 1 }
  end

  def render_index_csv
    render csv: Sku::CsvExporter.new.export(params)
  end

  def supplier_summary_export
    Sku::SupplierSummaryExporter.new.export(params)
  end
end
