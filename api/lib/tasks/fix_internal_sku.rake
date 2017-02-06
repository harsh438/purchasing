namespace :fix_data do
  desc "update internal sku with the correct product_id- element_id"
  task fix_internal_sku: :environment do
    logger = Logger.new(STDOUT)
    dup_option_values = Sku::FixInternalSku.new(logger)
    dup_option_values.process!
    # logger.info(dup_option_values.process!, logger)
  end
end

