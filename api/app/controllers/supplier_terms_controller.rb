class SupplierTermsController < ApplicationController
  def index
    supplierTerms = SupplierTerms::Search.new.search(params)
    respond_to do |format|
      format.json { render json: { terms: supplierTerms.map(&:as_json_with_url_and_supplier_name),
                                   total_pages: supplierTerms.total_pages,
                                   page: params[:page] } }
      format.csv { render csv: SupplierTerms::CsvExporter.new.export(params) }
    end
    #return render text: "hello"
    #render json: { terms: supplierTerms.map(&:as_json_with_url_and_supplier_name),
    #               total_pages: supplierTerms.total_pages,
    #               page: params[:page] }
  end

def to_csv(terms, options = {})
  CSV.generate(options) do |csv|
    csv << SupplierTerms.column_names + SupplierTerms.termslist
    terms.each do |term|
      csv << term.attributes.values_at(*SupplierTerms.column_names) + term.terms.values_at(*SupplierTerms.termslist)
    end
  end
end



  def show
    render json: SupplierTerms.find(params[:id]).as_json_with_url
  end
end
