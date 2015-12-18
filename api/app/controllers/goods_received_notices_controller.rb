class GoodsReceivedNoticesController < ApplicationController
  def index
    render json: GoodsReceivedOrder::WeeklyReporter.new.report(params)
  end
end
