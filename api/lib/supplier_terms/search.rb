class SupplierTerms::Search
  def search(params)
    suppliers = SupplierTerms.latest.includes(:supplier)
    suppliers = apply_filters(suppliers, params[:filters] || {})
    suppliers = suppliers.page(params[:page])
    suppliers
  end

  private

  def apply_filters(query, filters)
    if filters[:supplier_id].present?
      query = query.where(supplier_id: filters[:supplier_id])
    end

    if filters[:vendor_id].present?
      query = query.joins(supplier: :vendors).where(suppliers_to_brands: { 'BrandID' => filters[:vendor_id] })
    end

    if filters[:season].present?
      query = query.where(season: filters[:season])
    end

    apply_default_filter(query, filters)
  end

  def apply_default_filter(query, filters)
    if filters[:default] == '0'
      query
    else
      query.where(default: true)
    end
  end
end
