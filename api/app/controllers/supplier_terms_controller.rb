class SupplierTermsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_export(:csv) }
      format.xlsx { render_export(:xlsx) }
    end
  end

  def show
    render json: SupplierTerms.find(params[:id]).as_json_with_url_and_supplier_name
  end

  private

  def render_index_json
    supplier_terms = SupplierTerms::Search.new.search(params)
    render json: { terms: supplier_terms.map(&:as_json_with_url_and_supplier_name),
                   total_pages: supplier_terms.total_pages,
                   page: params[:page] }
  end

  def render_export(format)
    render format => SupplierTerms::Exporter.new.export(params)
  rescue SupplierTerms::Exporter::NoTermsSelectedError => e
    render plain: 'Please filter by terms'
  end
end
