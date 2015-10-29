class VendorsController < ApplicationController
  def index
    render json: Vendor.mapped
  end
end
