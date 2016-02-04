class GoodsReceivedNoticesController < ApplicationController
  def index
    render json: GoodsReceivedOrder::WeeklyReporter.new.report(params)
  end

  def create
    render json: GoodsReceivedNotice.create!(grn_attrs).as_json_with_purchase_orders
  end

  def show
    render json: grn.as_json_with_purchase_orders
  end

  def update
    grn.update!(grn_attrs)
    render json: grn.as_json_with_purchase_orders
  end

  def destroy
    grn.destroy
    render json: { success: true }
  end

  private

  def grn
    GoodsReceivedNotice.find(params[:id])
  end

  def grn_attrs
    grn_params = params.require(:goods_received_notice)
    grn_params.permit(:delivery_date,
                      goods_received_notice_events_attributes: [:id,
                                                                :purchase_order_id,
                                                                :units,
                                                                :cartons,
                                                                :pallets,
                                                                :_destroy])
  end
end
