class GoodsReceivedNotice::WeeklyReporter
  class InvalidParams < RuntimeError; end

  def report(params)
    start_date, end_date = date_range(params)

    notices = GoodsReceivedNotice.includes(:vendors)
                                 .not_archived
                                 .delivered_between(start_date..end_date)
                                 .not_on_weekends

    if params[:purchase_order_id].present?
      notices = notices.with_purchase_order_id(params[:purchase_order_id])
    end

    by_week = notices.reduce(NoticesByWeek.new(start_date, end_date), &:<<)
    counted = Counter.new.count(by_week)
    formatted = Formatter.new.format(counted)
  end

  private

  def date_range(params)
    params.values_at(:start_date, :end_date).map(&:to_date)
  rescue ArgumentError => e
    if e.message == 'invalid date'
      [Date.today.beginning_of_week - 2.weeks, (Date.today.beginning_of_week + 2.weeks + 4.days)]
    else
      raise e
    end
  end

  class NoticesByWeek < Hash
    def initialize(start_date, end_date)
      create_weeks_between(start_date, end_date)
    end

    def <<(notice)
      beginning_of_week = notice.delivery_date.beginning_of_week
      self[beginning_of_week][:notices_by_date] << notice
      self
    end

    private

    def create_weeks_between(start_date, end_date)
      (start_date..end_date).map(&:beginning_of_week).uniq.each do |beginning_of_week|
        self[beginning_of_week] ||= begin
          { week_num: beginning_of_week.strftime('%W'),
            start: beginning_of_week.to_s,
            end: (beginning_of_week + 5.days).to_s,
            notices_by_date: NoticesByDate.new(beginning_of_week) }
        end
      end
    end
  end

  class NoticesByDate < Hash
    def initialize(beginning_of_week)
      create_week_days(beginning_of_week)
    end

    def <<(notice)
      self[notice.delivery_date.to_s][:notices] << notice.as_json
      self
    end

    private

    def create_week_days(beginning_of_week)
      friday = beginning_of_week + 4.days

      (beginning_of_week..friday).each do |week_day|
        self[week_day.to_s] ||= begin
          { delivery_date: week_day.to_s,
            notices: [] }
        end
      end
    end
  end

  class Counter
    def count(notices_by_week)
      notices_by_week.reduce({}, &method(:count_notices_by_week))
    end

    private

    def count_notices_by_week(notices_by_week, by_week)
      beginning_of_week, week = by_week
      weeks_with_counts = week.merge(count_week_notices(week))
      notices_by_week.merge(beginning_of_week => weeks_with_counts)
    end

    def count_week_notices(week)
      notices_by_date = counts_notices_by_date(week[:notices_by_date])

      week.merge(notices_by_date: notices_by_date,
                 units: notices_by_date.values.sum { |by_date| by_date[:units] },
                 cartons: notices_by_date.values.sum { |by_date| by_date[:cartons] },
                 pallets: notices_by_date.values.sum { |by_date| by_date[:pallets] })
    end

    def counts_notices_by_date(notices_by_date)
      notices_by_date.reduce({}) do |with_counts, (date, notices)|
        with_counts.merge(date => count_notice_date(notices))
      end
    end

    def count_notice_date(notice_date)
      notice_date.merge(count_notices(notice_date[:notices]))
    end

    def count_notices(notices)
      { units: notices.sum { |notice| notice['units'] },
        cartons: notices.sum { |notice| notice['cartons'] },
        pallets: notices.sum { |notice| notice['pallets'] } }
    end
  end

  class Formatter
    include ActionView::Helpers::NumberHelper

    def format(notices_by_week)
      notices_by_week.reduce({}, &method(:format_notices_by_week))
    end

    private

    def format_notices_by_week(notices_by_week, by_week)
      beginning_of_week, week = by_week
      formatted_weeks = week.merge(format_week_notices(week))
      notices_by_week.merge(beginning_of_week => formatted_weeks)
    end

    def format_week_notices(week)
      notices_by_date = format_notices_by_date(week[:notices_by_date])
      format_counts(week.merge(notices_by_date: notices_by_date))
    end

    def format_notices_by_date(notices_by_date)
      notices_by_date.reduce({}) do |with_counts, (date, notice_date)|
        with_counts.merge(date => format_notice_date(notice_date))
      end
    end

    def format_notice_date(notice_date)
      format_counts(notice_date.merge(notices: format_notices(notice_date[:notices])))
    end

    def format_notices(notices)
      notices.map(&method(:format_counts))
    end

    def format_counts(item)
      units, cartons, pallets = item.symbolize_keys.values_at(:units, :cartons, :pallets)
      item.merge(units: format_count(units),
                 cartons: format_count(cartons),
                 pallets: format_count(pallets))
    end

    def format_count(count)
      number_with_delimiter(count.round)
    end
  end
end
