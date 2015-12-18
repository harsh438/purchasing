class GoodsReceivedOrder::WeeklyReporter
  def report(params)
    start_date, end_date = params.values_at(:start_date, :end_date).map(&:to_date)
    GoodsReceivedNotice.where(delivery_date: start_date..end_date)
  end
end
