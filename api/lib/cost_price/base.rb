module CostPrice
  class Base
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
      raise NotImplementedError.new('Ask the subclass')
    end

    private

    def update_purchase_order_cost(purchase_order_line, cost_price)
      purchase_order_line.cost = cost_price
      purchase_order_line.save!
    end

    def update_product_cost_price(current_product, cost_price)
      return true if current_product <= 0
      return true if @before_product == current_product
      Product.update(current_product, cost: cost_price)
      log("#{current_product} new cost price", cost_price)
      @before_product = current_product
    end


    def update_sku_cost_price(sku_id, cost_price)
      return false unless Sku.exists?(sku_id)
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
end
