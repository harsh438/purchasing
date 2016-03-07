class PurchaseOrdersController < ApplicationController
  def index
    render json: PurchaseOrder::Summariser.new.summary(params)
  end

  def list
    purchase_orders = PurchaseOrderLineItem.filter_status(status: 'balance')
                                           .where(vendor_id: params[:vendor_id])
                                           .group(:po_number)
                                           .map(&:purchase_order)
                                           .compact
                                           .reject(&:not_all_barcodes_populated?)
                                           .map { |po| { id: po.po_number } }
                                           .uniq

    render json: purchase_orders
  end

  def show
    respond_to do |format|
      format.json { render_index_json }
      format.csv { render_exporter(:csv) }
      format.xlsx { render_exporter(:xlsx) }
    end
  end

  def render_exporter(format)
    render format => PurchaseOrder::Exporter.new.export(params)
  end

  def cancel
    orders = PurchaseOrderLineItem.where('LENGTH(po_number) > 0')
                                  .where(po_number: params[:id])
    orders.each(&:cancel)
    render json: orders
  end
end
