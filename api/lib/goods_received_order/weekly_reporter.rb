class GoodsReceivedOrder::WeeklyReporter
  def report(params)
    start_date, end_date = params.values_at(:start_date, :end_date).map(&:to_date)
    notices = GoodsReceivedNotice.includes(:vendors).delivered_between(start_date..end_date).not_on_weekends
    by_week = notices.reduce(NoticesByWeek.new, &:<<)
    counted = Counter.new.count(by_week)
    formatted = Formatter.new.format(counted)
  end

  class NoticesByWeek < Hash
    def <<(notice)
      beginning_of_week = notice.delivery_date.beginning_of_week

      self[beginning_of_week] ||= begin
        { week_num: beginning_of_week.strftime('%W'),
          start: beginning_of_week.to_s,
          end: (beginning_of_week + 5.days).to_s,
          notices_by_date: NoticesByDate.new }
      end

      self[beginning_of_week][:notices_by_date] << notice
      self
    end
  end

  class NoticesByDate < Hash
    def <<(notice)
      self[notice.delivery_date.to_s] ||= begin
        { delivery_date: notice.delivery_date.to_s,
          notices: [] }
      end

      self[notice.delivery_date.to_s][:notices] << notice.as_json
      self
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
