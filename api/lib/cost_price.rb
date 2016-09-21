class CostPrice
  def initialize(logger, csv_path)
    @logger = logger
    @log_count = 0
    @csv_path = csv_path
    @before_product = false
  end

  def process!
    log_count_start('start update cost price for po')
    process_csv(csv_data)
  end

  def csv_data
    CSV.read(@csv_path, csv_options).map(&:to_hash)
  end

  def process_csv(csv_data)
    purchase_order_updated = csv_data.map do |data|
      @before_product = false
      log('Purchase order', data[:po])
      lines = purchase_order_details(data[:po])
      update_cost_prices(lines, data[:discount])
      data[:po]
    end
    "Updated Purchase Orders #{purchase_order_updated.join(',')}"
  end

  private

  def purchase_order_details(purchase_order_number)
    PurchaseOrderLineItem.where(po_number: purchase_order_number)
  end

  def update_cost_prices(purchase_order_lines, discount)
    purchase_order_lines.map do |purchase_order_line|
      log('Purchase order pid', purchase_order_line.try(:product_id))
      log('old cost price', purchase_order_line.try(:cost))
      supplier_price = purchase_order_line.try(:orderTool_SupplierListPrice)
      cost_price = calculate_cost_price(supplier_price, discount)
      update_purchase_order_cost(purchase_order_line, cost_price)
      log('new cost price', cost_price)
      update_sku_cost_price(purchase_order_line.sku_id, cost_price)
      product_id = purchase_order_line.try(:product_id)
      update_product_cost_price(product_id, cost_price)
      log_count_increment
    end
    true
  end

  def update_purchase_order_cost(purchase_order_line, cost_price)
    purchase_order_line.cost = cost_price
    purchase_order_line.save!
  end

  def update_product_cost_price(current_procduct, cost_price)
    return true if @before_product == current_procduct
    Product.update(current_procduct, cost: cost_price)
    log('#{current_procduct} new cost price', cost_price)
    @before_product = current_procduct
  end

  def calculate_cost_price(price, discount_percent)
    discount = (price / 100) * discount_percent.to_f
    price - discount
  end

  def update_sku_cost_price(sku_id, cost_price)
    log('new sku', cost_price)
    Sku.update(sku_id, cost_price: cost_price)
  end

  def csv_options
    {
      encoding: "UTF-8",
      headers: true,
      header_converters: :symbol,
      converters: :all
    }
  end

  def log(key, value)
    log = "#{key} => #{value}"
    @logger.info(log)
  end

  def log_count_start(message)
    @logger.info(message)
  end

  def log_count_increment(quantity = 1)
    @log_count += quantity
  end
end
