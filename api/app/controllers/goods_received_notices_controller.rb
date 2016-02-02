class GoodsReceivedNoticesController < ApplicationController
  def index
    render json: GoodsReceivedOrder::WeeklyReporter.new.report(params)
  end

  def create
    render json: GoodsReceivedNotice.create!(grn_attrs)
  end

  private

  def grn_attrs
    params.require(:goods_received_notice).permit(:delivery_date)
  end

end
