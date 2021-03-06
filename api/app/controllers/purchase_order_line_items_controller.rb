class PurchaseOrderLineItemsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_exporter(:csv) }
      format.xlsx { render_exporter(:xlsx) }
    end
  end

  def update
    orders = PurchaseOrderLineItem.where(id: params[:id])
    orders.each { |o| o.update!(permitted_params) }
    render json: orders
  end

  def cancel
    orders = PurchaseOrderLineItem.where(id: params[:id])
    orders.each(&:cancel)
    render json: orders
  end

  def uncancel
    orders = PurchaseOrderLineItem.where(id: params[:id])
    orders.each(&:uncancel)
    render json: orders
  end

  private

  def render_index_json
    export_url = url_for(params.merge(format: :xlsx))
    render json: PurchaseOrderLineItem::Search.new.search(params, export_url: export_url)
  end

  def render_exporter(format)
    render format => PurchaseOrderLineItem::Exporter.new.export(params)
  rescue PurchaseOrderLineItem::Filter::NoFiltersError => e
    render plain: 'Please select filters'
  end

  def permitted_params
    params.permit(:delivery_date, :quantity, :cost, :comment)
  end
end
