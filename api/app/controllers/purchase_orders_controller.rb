class PurchaseOrdersController < ApplicationController
  def index
    render json: PurchaseOrder::Summariser.new.summary(params)
  end

  def show
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_exporter(:csv) }
      format.xlsx { render_exporter(:xlsx) }
    end
  end

  def render_exporter(format)
    render format => PurchaseOrder::CsvExporter.new.export(params)
  end

  def cancel
    orders = PurchaseOrderLineItem.where('LENGTH(po_number) > 0')
                                  .where(po_number: params[:id])
    orders.each(&:cancel)
    render json: orders
  end
end
