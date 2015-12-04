class FiltersController < ApplicationController
  def vendors
    render json: Vendor.mapped.relevant
  end

  def suppliers
    render json: Supplier.mapped.relevant.alphabetical
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

  def buyers
    render json: SupplierBuyer.buyers
  end

  def buyer_assistants
    render json: SupplierBuyer.buyer_assistants
  end
end
