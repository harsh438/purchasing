# require_relative '../cost_price.rb'

namespace :purchase_order do
  desc "update the cost price for each item in a po"
  task :update_cost_price, [:csv_path] => :environment do |_t, args|
    abort('Missing csv path') if args[:csv_path].blank?
    csv_path = args[:csv_path]
    logger = Logger.new(STDOUT)
    abort("Invalid CSV path") if Dir[csv_path].empty?
    line_cost_price = CostPrice.new(logger, csv_path)
    logger.info(line_cost_price.process!)
  end
end
