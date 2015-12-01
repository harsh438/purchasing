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

    query
  end
end
