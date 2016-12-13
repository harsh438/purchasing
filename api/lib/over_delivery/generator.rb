class OverDelivery::Generator
  def initialize(attrs)
    @attrs = attrs.with_indifferent_access
    @line_item_adder = Order::LineItemAdder.new
    @exporter = Order::Exporter.new
  end

  def generate
    ActiveRecord::Base.transaction do
      @over_delivery = OverDelivery.create!(attrs.except(:po_numbers))
      order = Order.create!(order_attrs)
      line_item_adder.add(order, order_line_item_attrs)
      orders = Order.where(id: order.id).includes(:line_items, :exports)
      exporter.export(orders, extra_params)
    end
  end

  private

  attr_reader :attrs, :skus, :line_items, :line_item_adder, :exporter, :over_delivery

  def order_attrs
    {
      name: "OVER_#{over_delivery.id}",
      order_type: 'over_po',
      season: season
    }
  end

  def extra_params
    {
      operator: 'O_U_TOOL'
    }
  end

  def season
    @season ||= PurchaseOrderLineItem.season(attrs[:po_numbers])
  end

  def order_line_item_attrs
    [
      {
        internal_sku: attrs[:sku],
        manufacturer_size: manufacturer_size,
        season: season,
        cost: cost,
        quantity: attrs[:quantity],
        discount: 0,
        drop_date: Time.now.to_s(:db)
      }
    ]
  end

  def manufacturer_size
    skus.first.try(:manufacturer_size)
  end

  def skus
    @skus ||= Sku.where(sku: attrs[:sku], season: season)
  end

  def cost
    raise SkuNotFoundForSeason.new(attrs[:sku], season) if skus.blank?
    cost_value = OverDelivery::Cost.new(line_items, skus).process
    raise MissingItemsForCost if cost_value.nil?
    cost_value
  end

  def line_items
    @line_items ||= PurchaseOrderLineItem.where(po_number: attrs[:po_numbers],
                                                sku_id: skus.first.try(:id)
                                               )
                                         .order('id DESC')
                                         .first
  end

  class MissingItemsForCost < StandardError; end
  class SkuNotFoundForSeason < StandardError
    attr_reader :sku, :season
    def initialize(sku, season=nil)
      @sku = sku
      @season = season
    end
  end
end
