class SupplierTerms::Search
  def search(params)
    suppliers = SupplierTerms.latest.includes(:supplier)
    suppliers = SupplierTerms::Filter.new.apply(suppliers, params[:filters] || {})
    suppliers = suppliers.page(params[:page])
    suppliers
  end
end
