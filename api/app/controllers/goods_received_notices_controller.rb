class GoodsReceivedNoticesController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: GoodsReceivedNotice::WeeklyReporter.new.report(params) }
      format.xlsx { render xlsx: GoodsReceivedNotice::Exporter.new.export(params) }
    end
  end

  def create
    render json: GoodsReceivedNotice.create!(grn_attrs).as_json_with_purchase_orders_and_packing_list_urls
  end

  def show
    render json: grn.as_json_with_purchase_orders_and_packing_list_urls
  end

  def update
    grn.update!(grn_attrs)
    render json: grn.as_json_with_purchase_orders_and_packing_list_urls
  end

  def combine
    from = GoodsReceivedNotice.find(params[:from])
    GoodsReceivedNotice::Combiner.new.combine(to: grn, from: from)
    render json: grn.as_json_with_purchase_orders_and_packing_list_urls
  end

  def destroy
    grn.destroy
    render json: { success: true }
  end

  def delete_packing_list
    url = params[:packing_list_attributes][:list_url]
    grn.delete_packing_list_by_url!(url)
    render json: grn.as_json_with_purchase_orders_and_packing_list_urls
  end

  private

  def grn
    GoodsReceivedNotice.find(params[:id])
  end

  def grn_attrs
    grn_params = params.require(:goods_received_notice)
    grn_params.permit(:delivery_date,
                      :pallets,
                      packing_lists_attributes: [:id, :list, :list_file_name],
                      goods_received_notice_events_attributes: [:id,
                                                                :purchase_order_id,
                                                                :units,
                                                                :cartons,
                                                                :pallets,
                                                                :user_id,
                                                                :_destroy])
  end
end
