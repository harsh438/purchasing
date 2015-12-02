class VendorsController < ApplicationController
  def index
    vendors = Vendor::Search.new.search(params)
    render json: { vendors: vendors.includes(:details).as_json,
                   total_pages: vendors.total_pages,
                   page: params[:page] }
  end

  def create
    render json: Vendor.create!(create_vendor_attrs)
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update!(update_vendor_attrs)
    render json: vendor
  end

  def show
    render json: Vendor.find(params[:id]).to_json
  end

  private

  def update_vendor_attrs
    params.require(:vendor).permit(:name)
  end

  def create_vendor_attrs
    params.require(:vendor).permit(:id, :name)
  end
end
