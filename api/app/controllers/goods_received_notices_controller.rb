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

  def packing_lists_attrs
    [:id,
     :list,
     :list_file_name]
  end

  def events_attrs
    [:_destroy,
     :cartons,
     :id,
     :pallets,
     :purchase_order_id,
     :units,
     :user_id,
     :received,
     :status]
  end

  def condition_attrs
    [:booked_in,
     :id,
     :grn_id,
     :arrived_correctly,
     :cartons_good_condition,
     :packing_list_received,
     :grn_or_po_marked_on_cartons,
     :packing_list_outside_of_carton,
     :cartons_sequentially_numbered,
     :packed_correctly,
     :packed_correctly_issues_id,
     :cartons_markings_correct,
     :cartons_palletised_correctly,
     :packing_comments,
     :barcoded,
     :poly_bagged,
     :general_comments,
     :attachments,
     :items_in_quarantine]
  end

  def grn_attrs
    grn_params = params.require(:goods_received_notice)
    grn_params.permit(:delivery_date,
                      :pallets,
                      packing_lists_attributes: packing_lists_attrs,
                      goods_received_notice_events_attributes: events_attrs,
                      packing_condition_attributes: condition_attrs)

  end
end
