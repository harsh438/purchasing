class PackingListsController < ApplicationController
  def index
    render json: packing_lists
  end

  private

  def packing_lists
    date_from, date_to = date_range
    GoodsReceivedNotice.where(delivery_date: date_from..date_to)
                       .map(&:as_json_with_purchase_orders_and_packing_list_urls)
                       .flat_map do |goods_received_notice|
      goods_received_notice[:packing_list_urls].map do |packing_list_url|
        purchase_order_ids = goods_received_notice[:goods_received_notice_events].map do |grn_event|
          grn_event['purchase_order_id']
        end

        { grn: goods_received_notice['id'],
          vendor_name: goods_received_notice[:vendor_name],
          purchase_order_ids: purchase_order_ids,
          url: packing_list_url,
          delivery_date: goods_received_notice['delivery_date'].to_s }
      end
    end
  end

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
