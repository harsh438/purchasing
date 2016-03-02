class Sku::Updator
  def self.update(sku, params)
    ActiveRecord::Base.transaction do
      self.check_empty_size(params)
      sku.update!(params)
      Sku::Exporter.new.export(sku)
      self.update_option(sku, params) if params.include?(:manufacturer_size)
    end
  end

  private
  def self.update_option(sku, params)
    sku.option.update!(size: params[:manufacturer_size])
  end

  def self.check_empty_size(params)
    if params.include?(:manufacturer_size) and params[:manufacturer_size].strip.empty?
      raise Exceptions::SkuUpdateError, "Manufacturer size cannot be empty"
    end
  end
end
