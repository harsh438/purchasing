class FiltersController < ApplicationController
  def vendors
    render json: Vendor.mapped
  end

  def suppliers
    if params[:relevant]
      render json: Supplier.mapped.relevant.alphabetical
    else
      render json: Supplier.mapped.alphabetical
    end
  end

  def seasons
    render json: PurchaseOrderLineItem.seasons
  end

  def genders
    render json: PurchaseOrderLineItem.genders
  end

  def order_types
    render json: PurchaseOrderLineItem.order_types
  end

  def categories
    render json: LanguageCategory.relevant
  end

  def staff_members
    render json: StaffMember.names
  end

  def buyers
    render json: SupplierBuyer.buyers
  end

  def buyer_assistants
    render json: SupplierBuyer.buyer_assistants
  end

  def supplier_terms_list
    render json: SupplierTerms.stored_attributes[:terms]
  end
end
