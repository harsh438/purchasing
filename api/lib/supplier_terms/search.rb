require 'pp'

class SupplierTerms::Search
  def search(params)
    suppliers = SupplierTerms.latest.includes(:supplier)
    suppliers = apply_filters(suppliers, params[:filters] || {})
    suppliers = suppliers.page(params[:page])
    suppliers
  end

  private
  def apply_filters(query, filters)
    if filters[:suppliers].blank?.!
      query = query.where(:supplier_id => filters[:suppliers].split(','))
    end

    if filters[:vendor_ids].blank?.!
      query = query.joins(supplier: :vendors).where(suppliers_to_brands: { 'BrandID' => filters[:vendor_ids].split(',') })
    end

    if filters[:seasons].blank?.!
      query = query.where(:season => filters[:seasons].split(','))
    end

    apply_default_filter(query, filters)
  end

  private
  def apply_default_filter(query, filters)
    if filters[:default].blank? or filters[:default] == '1' or filters[:default] == 'true'
      query = query.where(:default => true)
    end
    query
  end
end
