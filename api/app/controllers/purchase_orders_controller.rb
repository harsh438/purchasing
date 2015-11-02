class PurchaseOrdersController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: PurchaseOrder::Search.new.search(params)
      end

      format.csv do
        render_csv
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

  def render_csv
    render csv: PurchaseOrder::CsvExporter.new.export(params)
  rescue PurchaseOrder::CsvExporter::NoFiltersError => e
    render plain: 'Please select filters'
  end
end
