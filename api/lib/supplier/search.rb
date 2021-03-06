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

    if filters[:buyer_name] or filters[:assistant_name]
      query = query.joins(:buyers)

      if filters[:buyer_name]
        query = query.where(supplier_buyers: { buyer_name: filters[:buyer_name] })
      end

      if filters[:assistant_name]
        query = query.where(supplier_buyers: { assistant_name: filters[:assistant_name] })
      end
    end

    if filters[:discontinued]
      query = query.where(supplier_details: { discontinued: filters[:discontinued] })
    end

    query
  end
end
