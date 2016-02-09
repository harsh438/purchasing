class GoodsReceivedNotice::Exporter
  def export(attrs)
    if attrs[:type] == 'month'
      export_month(attrs)
    elsif attrs[:type] == 'current'
        export_week(attrs)
    else
      raise 'GoodsReceivedNotice::Exporter#export attrs[:type] not recognised'
    end
  end

  private

  def export_week(attrs)
    export = Table::ViewModel.new
    export << grn_week_columns
    export.concat(grn_week_rows(attrs))

    export << po_columns.map(&:humanize)
    export.concat(week_po_rows(attrs))
  end

  def export_month(attrs)
    export = Table::ViewModel.new

    export << grn_columns.map(&:humanize)
    export.concat(grn_rows(attrs))

    export << po_columns.map(&:humanize)
    export.concat(po_rows(attrs))
  end


  def grn_week_columns
    %w(week
       delivery_date
       total_pallets
       total_cartons
       total_units)
  end

  def grn_columns
    %w(delivery_date
       grn
       total_pallets
       total_cartons
       total_units)
  end

  def po_columns
    %w(delivery_date
       original_delivery_date
       brand_name
       cartons
       total_pallets
       po
       grn
       total_units
       booked_in_date)
  end

  def grn_rows(attrs)
    GoodsReceivedNotice.where('MONTH(DeliveryDate) = ? AND YEAR(DeliveryDate) = ?',
                              attrs[:month].to_i,
                              attrs[:year])
                       .group('DeliveryDate')
                       .order('DeliveryDate')
                       .pluck('DeliveryDate',
                              'sum(PaletsExpected) as total_pallets',
                              'sum(CartonsExpected) as total_cartons',
                              'sum(TotalUnits) as total_units').map do |row|
      row[0] = row[0].to_s
      row
    end
  end

  def po_rows(attrs)
    GoodsReceivedNoticeEvent.includes(goods_received_notice: :vendors)
                            .where('MONTH(bookingin_events.DeliveryDate) = ? AND YEAR(bookingin_events.DeliveryDate) = ?',
                                   attrs[:month].to_i,
                                   attrs[:year].to_i)
                            .order('bookingin_events.DeliveryDate',
                                   'bookingin_events.grn')
                            .pluck('bookingin_events.DeliveryDate',
                                   'goods_received_number.DeliveryDate',
                                   'ds_vendors.venCompany',
                                   'bookingin_events.CartonsExpected',
                                   'bookingin_events.PaletsExpected',
                                   'bookingin_events.po',
                                   'bookingin_events.grn',
                                   'bookingin_events.TotalUnits',
                                   'bookingin_events.BookedInDate').map do |row|
      row[0] = row[0].to_s
      row[1] = row[1].to_s
      row[8] = row[8].to_s
      row
    end
  end



  def grn_week_rows(attrs)
    start_date, end_date = attrs.values_at(:start_date, :end_date).map(&:to_date)
    GoodsReceivedNotice.delivered_between(start_date..end_date)
                       .group('DeliveryDate')
                       .order('DeliveryDate')
                       .pluck('DeliveryDate',
                              'PaletsExpected as total_pallets',
                              'CartonsExpected as total_cartons',
                              'TotalUnits as total_units').map do |row|
      row[0] = row[0].to_s
      row
    end
  end


  def week_po_rows(attrs)
    start_date, end_date = attrs.values_at(:start_date, :end_date).map(&:to_date)
    GoodsReceivedNoticeEvent.includes(goods_received_notice: :vendors)
                            .where(delivery_date: start_date..end_date)
                            .order('bookingin_events.DeliveryDate',
                                   'bookingin_events.grn')
                            .pluck('bookingin_events.DeliveryDate',
                                   'goods_received_number.DeliveryDate',
                                   'ds_vendors.venCompany',
                                   'bookingin_events.CartonsExpected',
                                   'bookingin_events.PaletsExpected',
                                   'bookingin_events.po',
                                   'bookingin_events.grn',
                                   'bookingin_events.TotalUnits',
                                   'bookingin_events.BookedInDate').map do |row|
      row[0] = row[0].to_s
      row[1] = row[1].to_s
      row[8] = row[8].to_s
      row
    end
  end

end
