class PurchaseOrdersController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: { summary: {},
                       results: search.results,
                       more_results_available: !search.results.last_page?,
                       page: params[:page] }
      end

      format.csv do
        if search.filters.has_filters?
          render :nothing
        else
          render plain: 'Please select filters'
        end
      end
    end
  end

  def seasons
    render json: PurchaseOrder.seasons
  end

  def genders
    render json: PurchaseOrder.genders
  end

  def order_types
    render json: PurchaseOrder.order_types
  end

  private

  def search
    @search ||= Search.new(PurchaseOrder.with_summary, params)
  end
end
