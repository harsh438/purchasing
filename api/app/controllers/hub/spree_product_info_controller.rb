class Hub::SpreeProductInfo < ApplicationController

  def latest
    elible_products
  end

  private

  def eligible_products
    last_updated_time = Time.parse(params[:parameters][:last_imported_timestamp])
    Sku.where("updated_at > ?", last_updated_time)
  end
end
