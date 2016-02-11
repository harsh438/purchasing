class GoodsReceivedNotice::Exporter
  def export(attrs)
    if attrs[:type] == 'month'
      export_month(attrs)
    elsif attrs[:type] == 'range'
      export_range(attrs)
    else
      raise 'GoodsReceivedNotice::Exporter#export attrs[:type] not recognised'
    end
  end

  private

  def export_month(attrs)
    export = Table::ViewModel.new

    export << grn_columns.map(&:humanize)
    export.concat(grn_rows_for_month(attrs))

    export << po_columns.map(&:humanize)
    export.concat(po_rows_for_month(attrs))
  end

  def export_range(attrs)
    export = Table::ViewModel.new

    export << grn_columns.map(&:humanize)
    export.concat(grn_rows_for_range(attrs))

    export << po_columns.map(&:humanize)
    export.concat(po_rows_for_range(attrs))
  end

  def grn_columns
    %w(week
       delivery_date
       total_units
       total_cartons
       total_pallets)
  end

  def po_columns
    %w(week
       delivery_date
       original_delivery_date
       brand_name
       grn
       po
       units
       cartons
       pallets
       booked_in_date)
  end

  def grn_rows_for_month(attrs)
    grn_rows(GoodsReceivedNotice.where('MONTH(goods_received_number.DeliveryDate) = ?', attrs[:month].to_i)
                                .where('YEAR(goods_received_number.DeliveryDate) = ?', attrs[:year]))
  end

  def grn_rows_for_range(attrs)
    start_date, end_date = attrs.values_at(:start_date, :end_date).map(&:to_date)
    grn_rows(GoodsReceivedNotice.delivered_between(start_date..end_date))
  end

  def grn_rows(grn)
    grn.not_archived
       .group('goods_received_number.DeliveryDate')
       .order('goods_received_number.DeliveryDate')
       .pluck('WEEK(goods_received_number.DeliveryDate)',
              'goods_received_number.DeliveryDate',
              'sum(goods_received_number.TotalUnits) as total_units',
              'sum(goods_received_number.CartonsExpected) as total_cartons',
              'sum(goods_received_number.PaletsExpected) as total_pallets').map do |row|
      row[1] = row[1].to_s
      row
    end
  end

  def po_rows_for_month(attrs)
    po_rows(GoodsReceivedNoticeEvent.includes(:goods_received_notice)
                                    .where('MONTH(bookingin_events.DeliveryDate) = ? AND YEAR(bookingin_events.DeliveryDate) = ?',
                                           attrs[:month].to_i,
                                           attrs[:year].to_i))
  end

  def po_rows_for_range(attrs)
    start_date, end_date = attrs.values_at(:start_date, :end_date).map(&:to_date)
    po_rows(GoodsReceivedNoticeEvent.includes(:goods_received_notice)
                                    .where(delivery_date: start_date..end_date))
  end

  def po_rows(grn_events)
    po_rows = grn_events.order('bookingin_events.DeliveryDate',
                               'bookingin_events.grn')
                        .pluck('WEEK(bookingin_events.DeliveryDate)',
                               'bookingin_events.DeliveryDate',
                               'goods_received_number.DeliveryDate',
                               'bookingin_events.BrandID',
                               'bookingin_events.grn',
                               'bookingin_events.po',
                               'bookingin_events.TotalUnits',
                               'bookingin_events.CartonsExpected',
                               'bookingin_events.PaletsExpected',
                               'bookingin_events.BookedInDate')

    vendors = Vendor.where(id: po_rows.map { |row| row[3] }).index_by(&:id)

    po_rows.map do |row|
      row[1] = row[1].to_s
      row[2] = row[2].to_s
      row[3] = vendors[row[3]].name
      row[8] = row[8].to_s
      row
    end
  end
end
