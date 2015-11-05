class PurchaseOrdersController < ApplicationController
  protect_from_forgery except: [:cancel, :cancel_order]

  def index
    respond_to do |format|
      format.json { render_json }
      format.csv { render_csv }
    end
  end

  def update
    order = PurchaseOrder.find(params[:id])
    order.update_attributes(permitted_params)
    render json: { id: params[:id] }
  end

  def cancel
    orders = PurchaseOrder.where(id: params[:id])
    orders.values.each(&:cancel)
    render json: orders
  end

  def cancel_order
    ids = PurchaseOrder.find(params[:id]).try(:cancel_order)
    render json: { ids: ids }
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

  def render_json
    export_url = url_for(params.merge(format: :csv))
    render json: PurchaseOrder::Search.new.search(params, export_url: export_url)
  end

  def render_csv
    render csv: PurchaseOrder::CsvExporter.new.export(params)
  rescue PurchaseOrder::Filter::NoFiltersError => e
    render plain: 'Please select filters'
  end

  def permitted_params
    params.permit(:delivery_date)
  end
end
