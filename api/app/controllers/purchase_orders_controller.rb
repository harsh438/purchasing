class PurchaseOrdersController < ApplicationController
  def index
    results = Search.new(PurchaseOrder, params).results
    
    render json: { summary: {},
                   results: results,
                   more_results_available: !results.last_page?,
                   page: params[:page] }
  end

  def seasons
    render json: PurchaseOrder.seasons
  end

  def lead_genders
    render json: PurchaseOrder.lead_genders
  end
end
