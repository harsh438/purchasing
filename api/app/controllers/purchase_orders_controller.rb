class PurchaseOrdersController < ApplicationController
  def index
    render json: { summary: {},
                   results: Search.new(PurchaseOrder, params).results,
                   more_results_available: true,
                   page: params[:page] }
  end

  def seasons
    render json: PurchaseOrder.seasons
  end

  def lead_genders
    render json: PurchaseOrder.lead_genders
  end
end
