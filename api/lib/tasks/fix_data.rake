namespace :fix_data do
  desc "Remove duplicate options"
  task remove_duplicated_spree_option: :environment do
    logger = Logger.new(STDOUT)
    dup_option_values = RemoveDuplicatedOption.new(logger)
    logger.info(dup_option_values.process!, logger)
  end
end


