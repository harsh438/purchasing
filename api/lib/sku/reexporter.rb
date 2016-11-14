require 'csv'

class Sku::Reexporter
  attr_reader :exporter, :logger, :csv_path

  def initialize(exporter, logger, csv_path)
    @csv_path = csv_path
    @exporter = exporter
    @logger = logger
  end

  def re_export
    CSV.open(File.expand_path(csv_path)) do |rows|
      rows.each do |row|
        sku = Sku.find_by(id: row[0].to_i)
        logger.info("before: #{sku.inspect}")
        exported_sku = exporter.export(sku)
        logger.info("after: #{exported_sku.inspect}")
      end
    end
  end
end
