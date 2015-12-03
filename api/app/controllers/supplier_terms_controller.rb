class SupplierTermsController < ApplicationController
  def index
    supplierTerms = SupplierTerms::Search.new.search(params)
    render json: { terms: supplierTerms.map(&:as_json_with_url_and_supplier_name),
                   total_pages: supplierTerms.total_pages,
                   page: params[:page] }
  end

  def show
    render json: SupplierTerms.find(params[:id]).as_json_with_url
  end
end
