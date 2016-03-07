class Hub::PurchaseOrdersController < ApplicationController
  def latest
    render json: PurchaseOrder::HubExporter.new.export(params)
  end
end
