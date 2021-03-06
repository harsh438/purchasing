class GoodsReceivedNotice::Exporter
  def export(attrs)
    case attrs[:type]
    when 'date'
      export_day(attrs)
    when 'month'
      export_month(attrs)
    when 'range'
      export_range(attrs)
    else
      raise 'GoodsReceivedNotice::Exporter#export attrs[:type] not recognised'
    end
  end

  private

  def export_day(attrs)
    export = Table::ViewModel.new
    date = attrs[:date].to_date

    export << grn_columns.map(&:humanize)
    export.concat(grn_rows_for_day(date))

    export << po_columns.map(&:humanize)
    export.concat(po_rows_for_day(date))
  end

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
       booked_in_date
       book_in_by
       season
       total_purchase_order_cost)
  end

  def grn_rows_for_day(date)
    grn_rows(GoodsReceivedNotice.delivered_between(date))
  end

  def po_rows_for_day(date)
    po_rows(GoodsReceivedNoticeEvent.includes(:goods_received_notice)
                                    .where(delivery_date: date))
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
    grn_rows = grn.not_on_weekends
                  .group('goods_received_number.DeliveryDate')
                  .order('goods_received_number.DeliveryDate')
                  .pluck('WEEK(goods_received_number.DeliveryDate)',
                         'goods_received_number.DeliveryDate',
                         'sum(goods_received_number.TotalUnits) as total_units',
                         'sum(goods_received_number.CartonsExpected) as total_cartons',
                         'sum(goods_received_number.PaletsExpected) as total_pallets')

    grn_rows.map do |row|
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
    po_rows = grn_events.not_on_weekends
                        .order('bookingin_events.DeliveryDate',
                               'bookingin_events.grn')
                        .pluck('WEEK(bookingin_events.DeliveryDate)',
                               'goods_received_number.DeliveryDate',
                               'goods_received_number.LastDeliveryDate',
                               'bookingin_events.BrandID',
                               'bookingin_events.grn',
                               'bookingin_events.po',
                               'bookingin_events.TotalUnits',
                               'bookingin_events.CartonsExpected',
                               'bookingin_events.PaletsExpected',
                               'bookingin_events.BookedInDate',
                               'bookingin_events.UserID')
    po_rows_add_purchase_order_data(po_rows)
    po_rows.map(&method(:po_row).curry.call(vendors(po_rows), users(po_rows)))
  end

  def po_rows_add_purchase_order_data(po_rows)
    po_data = PurchaseOrder.where(id: po_rows.map { |po_row| po_row[5] })
                           .joins(:line_items)
                           .group(:po_num)
                           .pluck(:po_num, :po_season, 'sum(cost)')
    po_rows.each do |po_row|
      po_number = po_row[5]
      po_fields = po_data.find { |po| po[0] === po_number }
      po_row.concat(po_fields.slice(1, 2))
    end
  end

  def vendors(po_rows)
    Vendor.where(id: po_rows.map { |row| row[3] }).index_by(&:id)
  end

  def users(po_rows)
    User.where(id: po_rows.map { |row| row[10] }).index_by(&:id)
  end

  def po_row(vendors, users, row)
    delivery_date, original_delivery_date, vendor_id = row[1..3]
    pallets_expected = row[8]
    user_id = row[10]

    row[1] = delivery_date.to_s
    row[2] = original_delivery_date.to_s || delivery_date.to_s

    if vendors[vendor_id].present?
      row[3] = vendors[vendor_id].name
    else
      Raven.capture_message("GoodsReceivedNotice::Exporter could not find vendor name for '#{vendor_id}'")
    end

    row[8] = pallets_expected.to_s
    row[10] = users[user_id].try(:name)
    row
  end
end
