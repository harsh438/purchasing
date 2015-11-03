class VendorsController < ApplicationController
  def index
    render json: Vendor.mapped.relevant
  end
end
