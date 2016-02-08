class PackingListsController < ApplicationController
  def index
    date_from, date_to = date_range
    render json: GoodsReceivedNotice.where(delivery_date: date_from..date_to)
                                    .map(&:as_json_with_purchase_orders_and_packing_list_urls)
  end

  private

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
