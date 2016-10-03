class Sku::Updator
  def self.update(sku, params)
    ActiveRecord::Base.transaction do
      self.check_empty_size(params, sku)
      sku.update!(params)
      Sku::Exporter.new.export(sku)
      self.update_option(sku, params) if params.include?(:manufacturer_size)
      sku.touch
    end
  end

  private
  def self.update_option(sku, params)
    if sku.option.present?
      sku.option.update!(size: params[:manufacturer_size])
    end
  end

  def self.check_empty_size(params, sku)
    size = (params[:manufacturer_size] || '').strip
    old_size = (sku.manufacturer_size || '').strip
    if params.include?(:manufacturer_size) and size.blank? and old_size.present?
      raise Exceptions::SkuUpdateError, 'Manufacturer size cannot be empty'
    end
  end
end
