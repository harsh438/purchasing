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

    if filters[:vendor_id]
      query = query.joins(:supplier_vendors).where(suppliers_to_brands: { 'BrandID' => filters[:vendor_id] })
    end

    if filters[:discontinued]
      query = query.where(supplier_details: { discontinued: filters[:discontinued] })
    end

    query
  end
end
