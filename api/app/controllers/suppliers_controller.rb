class SuppliersController < ApplicationController
  def index
    suppliers = Supplier::Search.new.search(params)
    render json: { suppliers: suppliers.as_json(include: :contacts),
                   total_pages: suppliers.total_pages,
                   page: params[:page] }
  end

  def create
    render json: Supplier.create!(full_supplier_attrs)
  end

  def update
    supplier = Supplier.find(params[:id])
    supplier.update!(full_supplier_attrs)
    render json: supplier.as_json(include: [:contacts, :terms])
  end

  def show
    render json: Supplier.find(params[:id]).as_json(include: [:contacts, :terms])
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
                                     :returns_process,
                                     terms: [:season, :confirmation] + SupplierTerms.stored_attributes[:terms])
  end

  def supplier_details_attrs
    params.require(:supplier).permit(:invoicer_name,
                                     :account_number,
                                     :country_of_origin,
                                     :needed_for_intrastat,
                                     :discontinued)
  end

  def supplier_contacts_attrs
    params.require(:supplier).permit(contacts_attributes: [:name,
                                                           :title,
                                                           :email,
                                                           :mobile,
                                                           :landline])
  end

  def full_supplier_attrs
    supplier_attrs.merge(details_attributes: supplier_details_attrs)
                  .merge(supplier_contacts_attrs)
  end
end
