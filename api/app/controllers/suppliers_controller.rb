class SuppliersController < ApplicationController
  def index
    suppliers = Supplier::Search.new.search(params)
    if params[:name_only]
      return render json: { suppliers: Supplier.select(:name, :id).all }
    else
      return render json: { suppliers: suppliers.map(&:as_json_with_details_buyers_vendors_contacts_and_terms),
                     total_pages: suppliers.total_pages,
                     page: params[:page] }
    end
  end

  def create
    render json: Supplier.create!(full_supplier_attrs).as_json_with_details_buyers_vendors_contacts_and_terms
  end

  def update
    supplier = Supplier.find(params[:id])
    supplier.update!(full_supplier_attrs)
    render json: supplier.as_json_with_details_buyers_vendors_contacts_and_terms
  end

  def show
    render json: Supplier.find(params[:id]).as_json_with_details_buyers_vendors_contacts_and_terms
  end

  private

  def supplier_attrs
    params.require(:supplier).permit(:id,
                                     :name,
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
                                     :needed_for_intrastat,
                                     :discontinued)
  end

  def supplier_contacts_attrs
    params.require(:supplier).permit(contacts_attributes: [:id,
                                                           :name,
                                                           :title,
                                                           :email,
                                                           :mobile,
                                                           :landline])
  end

  def supplier_terms_attrs
    params.require(:supplier).permit(terms: [:season,
                                             :confirmation,
                                             :confirmation_file_name] + SupplierTerms.stored_attributes[:terms])
  end

  def supplier_buyers_attrs
    params.require(:supplier).permit(buyers_attributes: [:id,
                                                         :department,
                                                         :buyer_name,
                                                         :assistant_name,
                                                         :business_unit])
  end

  def full_supplier_attrs
    supplier_attrs.merge(details_attributes: supplier_details_attrs)
                  .merge(supplier_contacts_attrs)
                  .merge(supplier_terms_attrs)
                  .merge(supplier_buyers_attrs)
  end
end
