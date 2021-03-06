class Order::LineItemAdder
  def add(order, line_items_attrs)
    ActiveRecord::Base.transaction do
      line_items_attrs.each do |line_item_attrs|
        if line_item_attrs[:internal_sku].present?
          sku = find_sku(order, line_item_attrs)
          order.line_items.create!(line_item_and_sku_attrs(line_item_attrs, sku))
        end
      end
    end
  end

  private

  def preorder?(line_item_attrs)
    line_item_attrs[:internal_sku].present? and
      line_item_attrs[:season].present?
  end

  def find_sku(order, line_item_attrs)
    query = { sku: line_item_attrs[:internal_sku] }
    season = line_item_attrs[:season] || order.season
    if season.present?
      query[:season] = season
    end
    Sku.order(created_at: :desc).find_by!(query)
  rescue ActiveRecord::RecordNotFound
    raise Order::SkuNotFound.new(line_item_attrs[:internal_sku], season)
  end

  def line_item_and_sku_attrs(line_item_attrs, sku)
    { sku: sku,
      internal_sku: sku.sku,
      cost: line_item_attrs[:cost] || sku.cost_price,
      quantity: line_item_attrs[:quantity],
      discount: line_item_attrs[:discount],
      drop_date: line_item_attrs[:drop_date],
      product_id: sku.product_id,
      option_id: sku.option_id || 0,
      vendor_id: sku.vendor_id,
      season: sku.season.nickname,
      product_name: sku.product_name,
      gender: sku.gender,
      reporting_pid: sku.product_id }
  end
end
