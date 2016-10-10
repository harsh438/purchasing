namespace :sku do
  desc "Accepts csv of sku_ids. One id per line. Re-exports them"
  task :reexport, [:csv_path] => :environment do |_t, args|
    csv_path = args[:csv_path]
    exporter = Sku::Exporter.new
    logger =Logger.new(STDOUT)

    reexporter = Sku::Reexporter.new(exporter, logger, csv_path)
    reexporter.re_export
    puts "You just exported all the skus. Now go get 'em champ"
  end
end
