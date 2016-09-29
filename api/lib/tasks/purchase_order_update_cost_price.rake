require_relative '../cost_price/actual_cost_spec.rb'
require_relative '../cost_price/purchase_order_by_percent.rb'

namespace :purchase_order do
  desc "update the cost price for each item in a po"
  task :update_cost_price, [:csv_path] => :environment do |_t, args|
    abort('Missing csv path') if args[:csv_path].blank?
    csv_path = args[:csv_path]
    abort('Missing update_type') if args[:update_type].blank?
    update_type = args[:update_type]

    logger = Logger.new(STDOUT)
    abort("Invalid CSV path") if Dir[csv_path].empty?

    if update_type == "percent"
      line_cost_price = CostPrice::PurchaseOrderByPercent.new(logger, csv_path)
    elsif update_type == "actual_cost"
      line_cost_price = CostPrice::ActualCost.new(logger, csv_path)
    end

    logger.info(line_cost_price.process!)
  end
end
