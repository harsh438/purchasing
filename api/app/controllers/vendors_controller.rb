class VendorsController < ApplicationController
  def index
    vendors = Vendor::Search.new.search(params)
    render json: { brands: vendors.map { |v| { id: vendor.id, name: vendor.name } },
                   total_pages: vendors.total_pages,
                   page: params[:page] }
  end

  def create
    render json: Supplier.create!(vendor_attrs)
  end

  private

  def vendor_attrs
    params.require(:brand).permit(:id, :name)
  end
end
