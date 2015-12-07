class SupplierTermsController < ApplicationController
  def index
    supplierTerms = SupplierTerms::Search.new.search(params)

    respond_to do |format|
      format.json { render json: { terms: supplierTerms.map(&:as_json_with_url_and_supplier_name),
                                   total_pages: supplierTerms.total_pages,
                                   page: params[:page] } }
      format.csv { render csv: SupplierTerms::CsvExporter.new.export(params) }
    end
  end

  def show
    render json: SupplierTerms.find(params[:id]).as_json_with_url
  end
end
