class PurchaseOrdersController < ApplicationController
  protect_from_forgery except: [:cancel, :cancel_order, :update]

  def index
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_index_csv }
    end
  end

  def summary
    render json: PurchaseOrder::Search.new.summary(params)
  end

  def update
    orders = PurchaseOrder.where(id: params[:id])
    orders.each { |o| o.update!(permitted_params) }
    render json: orders
  end

  def cancel
    orders = PurchaseOrder.where(id: params[:id])
    orders.each(&:cancel)
    render json: orders
  end

  def cancel_order
    orders = PurchaseOrder.where('LENGTH(po_number) > 0').where(po_number: params[:po_number])
    orders.each(&:cancel)

    render json: orders
  end

  def uncancel
    orders = PurchaseOrder.where(id: params[:id])
    orders.each(&:uncancel)
    render json: orders
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

  def render_index_json
    export_url = url_for(params.merge(format: :csv))
    render json: PurchaseOrder::Search.new.search(params, export_url: export_url)
  end

  def render_index_csv
    render csv: PurchaseOrder::CsvExporter.new.export(params)
  rescue PurchaseOrder::Filter::NoFiltersError => e
    render plain: 'Please select filters'
  end

  def permitted_params
    params.permit(:delivery_date, :quantity, :cost)
  end
end
