class GoodsReceivedNoticesController < ApplicationController
  def index
    start_date, end_date = params.values_at(:start_date, :end_date).map(&:to_date)
    render json: GoodsReceivedNotice.where(delivery_date: start_date..end_date)
  end
end
