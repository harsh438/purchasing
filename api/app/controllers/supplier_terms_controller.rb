class SupplierTermsController < ApplicationController
  def show
    render json: SupplierTerms.find(params[:id]).as_json_with_url
  end
end
