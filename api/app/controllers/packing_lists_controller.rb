class PackingListsController < ApplicationController
  def index
    render json: packing_lists
  end

  private

  def grn_paper_url(grn)
    "https://www.sdometools.com/tools/bookingin_tool/grn_big_paper.php?grn=#{grn}"
  end

  def check_sheet_url(grn)
    "https://www.sdometools.com/tools/bookingin_tool/goods_in_check_sheet.php?grn=#{grn}"
  end

  def packing_lists
    date_from, date_to = date_range
    GoodsReceivedNotice.where(delivery_date: date_from..date_to)
                       .map(&:as_json_with_purchase_orders_and_packing_list_urls)
                       .flat_map do |goods_received_notice|
      purchase_order_ids = goods_received_notice[:goods_received_notice_events].map do |grn_event|
        grn_event['purchase_order_id']
      end

      { grn: goods_received_notice['id'],
        vendor_name: goods_received_notice[:vendor_name],
        purchase_order_ids: purchase_order_ids,
        packing_list_urls: goods_received_notice[:packing_list_urls],
        delivery_date: goods_received_notice['delivery_date'].to_s,
        grn_paper_url: grn_paper_url(goods_received_notice['id']),
        check_sheet_url: check_sheet_url(goods_received_notice['id']) }
    end
  end

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
