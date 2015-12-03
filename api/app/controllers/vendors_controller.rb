class VendorsController < ApplicationController
  def index
    vendors = Vendor::Search.new.search(params)
    render json: { vendors: vendors.map(&:as_json_with_details_and_suppliers),
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
    params.require(:vendor).permit(:name).merge(details_attributes: detail_attrs)
  end

  def create_vendor_attrs
    params.require(:vendor).permit(:id, :name).merge(details_attributes: detail_attrs)
  end

  def detail_attrs
    params.require(:vendor).permit(:discontinued)
  end
end