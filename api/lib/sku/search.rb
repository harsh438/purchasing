class Sku::Search
  def search(params)
    skus = Sku.latest.includes(:vendor, :language_category, :barcodes)
    skus = apply_filters(skus, params[:filters] || {})
    skus = skus.page(params[:page]) unless params[:no_paging]
    skus
  end

  private

  def apply_filters(skus, filters)
    if filters[:sku].present?
      skus = skus.where(sku: filters[:sku])
    end

    if filters[:vendor_id].present?
      skus = skus.where(vendor_id: filters[:vendor_id])
    end

    if filters[:season].present?
      skus = skus.where(season: filters[:season])
    end

    if filters[:without_barcodes].present?
      unless filters[:season].present?
        message = 'Season is mandatory if without barcode is selected'
        raise Exceptions::InvalidSearchFilters, message
      end
      skus = skus.where(barcodes: { id: nil })
    end

    skus
  end
end
