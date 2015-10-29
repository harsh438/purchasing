class PurchaseOrdersController < ApplicationController
  before_action :load_purchase_orders

  def index
    render json: @purchase_orders
  end

  private

  def load_purchase_orders
    @purchase_orders = filter_purchase_orders
  end

  def filter_purchase_orders
    @purchase_orders = PurchaseOrder
    @purchase_orders = @purchase_orders.where(vendor_id: po_attrs[:vendor_id]) if po_attrs[:vendor_id]
    @purchase_orders = @purchase_orders.page(po_attrs[:page])
  end

  def po_attrs
    params.permit(:page, :vendor_id, :format, :constraints)
  end
end
