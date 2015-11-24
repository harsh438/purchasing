class SuppliersController < ApplicationController
  def create
    render json: Supplier.create!(supplier_attrs.merge(details_attributes: supplier_details_attrs))
  end

  def show
    render json: Supplier.find(params[:id])
  end

  private

  def supplier_attrs
    params.require(:supplier).permit(:name,
                                     :returns_address_name,
                                     :returns_address_number,
                                     :returns_address_1,
                                     :returns_address_2,
                                     :returns_address_3,
                                     :returns_postal_code,
                                     :returns_process)
  end

  def supplier_details_attrs
    params.require(:supplier).permit(:invoicer_name,
                                     :account_number,
                                     :country_of_origin,
                                     :needed_for_intrastat)
  end
end
