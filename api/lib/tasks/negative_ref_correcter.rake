namespace :studio do
  desc "Correct negative_refs in product_image table"
  task :negative_ref_correction => [:environment] do
    logger = Logger.new(STDERR)
    logger.formatter = proc { |severity, datetime, _progname, msg|
      format('[%s] %s -- %s', datetime, severity, msg)
    }

    service = ProductImageNegativeRefAdjustmentService.new
    service.adjust(logger)
  end
end
