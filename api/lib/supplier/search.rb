class Supplier::Search
  def search(params)
    suppliers = Supplier.latest.with_details
    suppliers = apply_filters(suppliers, params[:filters] || {})
    suppliers = suppliers.page(params[:page])
    suppliers
  end

  private

  def apply_filters(query, filters)
    if filters[:name]
      query = query.where('SupplierName LIKE ?', "%#{filters[:name]}%")
    end

    if filters[:discontinued]
      query = query.where(supplier_details: { discontinued: filters[:discontinued] })
    end

    query
  end
end
