class Supplier::Search
  def search(params)
    suppliers = Supplier.latest
    suppliers = apply_filters(suppliers, params[:filters] || {})
    suppliers = suppliers.page(params[:page])
    suppliers
  end

  private

  def apply_filters(query, filters)
    if filters[:name]
      query.where('SupplierName LIKE ?', "%#{filters[:name]}%")
    else
      query
    end
  end
end
