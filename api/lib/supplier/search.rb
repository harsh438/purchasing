class Supplier::Search
  def search(params)
    suppliers = Supplier.latest.includes(:details, :contacts, :terms, vendors: :details)
    suppliers = apply_filters(suppliers, params[:filters] || {})
    suppliers = suppliers.page(params[:page])
    suppliers
  end

  private

  def apply_filters(query, filters)
    if filters[:name]
      query = query.where('SupplierName LIKE ?', "%#{filters[:name]}%")
    end

    if filters[:vendor_id]
      query = query.joins(:supplier_vendors).where(suppliers_to_brands: { 'BrandID' => filters[:vendor_id] })
    end

    if filters[:default_only].?
      query = query.where(supplier_details: { discontinued: filters[:discontinued] })
    end

    query
  end
end
