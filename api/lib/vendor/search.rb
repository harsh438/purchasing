class Vendor::Search
  def search(params)
    vendors = Vendor.relevant.latest
    vendors = apply_filters(vendors, params[:filters] || {})
    vendors = vendors.page(params[:page])
    vendors
  end

  private

  def apply_filters(query, filters)
    if filters[:name]
      query = query.where('venCompany LIKE ?', "%#{filters[:name]}%")
    end

    if filters[:supplier_id]
      query = query.joins(:supplier_vendors).where(suppliers_to_brands: { SupplierID: filters[:supplier_id] })
    end

    query
  end
end
