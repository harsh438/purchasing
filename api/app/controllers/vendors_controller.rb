class VendorsController < ApplicationController
  def index
    vendors = Vendor::Search.new.search(params)
    render json: { vendors: vendors.map { |v| { id: vendor.id, name: vendor.name } },
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
    render json: Vendor.find(params[:id])
  end

  private

  def update_vendor_attrs
    params.permit(:name)
  end

  def create_vendor_attrs
    params.require(:vendor).permit(:id, :name)
  end
end
