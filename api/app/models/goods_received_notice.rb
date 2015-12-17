class GoodsReceivedNotice < ActiveRecord::Base
  self.table_name = :goods_received_number
  self.primary_key = :grn

  include LegacyMappings

  map_attributes id: :grn,
                 units: :TotalUnits,
                 cartons: :CartonsExpected,
                 pallets: :PaletsExpected,
                 delivery_date: :DeliveryDate,
                 received: :isReceived,
                 checking: :isChecking,
                 checked: :isChecked,
                 processing: :isProcessing,
                 processed: :isProcessed,
                 received_at: :DateReceived,
                 page_count: :NoOfPages,
                 units_received: :UnitsReceived,
                 cartons_received: :CartonsReceived

  belongs_to :order, foreign_key: :OrderID
  has_one :vendor, through: :order

  belongs_to :vendor, foreign_key: :orderTool_venID
  has_many :goods_received_notice_events

  def received_at
    date = super

    unless date.to_s === '00/00/0000' or date.to_s === '01/01/0001'
      date
    end
  end

  def late?
    delivery_date < Date.today
  end

  def status
    if processed?
      :received
    elsif processing?
      :received
    elsif checked?
      :received
    elsif checking?
      :received
    elsif received?
      :delivered
    elsif late?
      :late
    else
      :balance
    end
  end

  def brand_name
    vendors.map(&:name).join(', ')
  end

  def as_json(options = {})
    super.tap do |grn|
      grn[:delivery_date] = grn['delivery_date'].to_s
      grn[:status] = status
    end
  end
end
