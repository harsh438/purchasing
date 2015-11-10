class PurchaseOrderLineItemsController < ApplicationController
  protect_from_forgery except: [:upate, :cancel, :uncancel]

  def index
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_index_csv }
    end
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

  def uncancel
    orders = PurchaseOrder.where(id: params[:id])
    orders.each(&:uncancel)
    render json: orders
  end

  private

  def render_index_json
    export_url = url_for(params.merge(format: :csv))
    render json: PurchaseOrderLineItem::Search.new.search(params, export_url: export_url)
  end

  def render_index_csv
    render csv: PurchaseOrderLineItem::CsvExporter.new.export(params)
  rescue PurchaseOrderLineItem::Filter::NoFiltersError => e
    render plain: 'Please select filters'
  end

  def permitted_params
    params.permit(:delivery_date, :quantity, :cost)
  end
end
