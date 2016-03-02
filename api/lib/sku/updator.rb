class Sku::Updator
  def self.update(sku, params)
    ActiveRecord::Base.transaction do
      sku.update!(params)
      Sku::Exporter.new.export(sku)
      self.update_option(sku, params) if params.include?(:manufacturer_size)
    end
  end

  private
  def self.update_option(sku, params)
    sku.option.update!(size: params[:manufacturer_size])
  end
end
