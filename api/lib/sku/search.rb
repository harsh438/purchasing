class Sku::Search
  def search(params)
    skus = Sku.latest.includes(:vendor, :language_category, :barcodes)
    skus = apply_filters(skus, params[:filters] || {})
    skus = skus.page(params[:page])
    skus
  end

  private

  def apply_filters(skus, filters)
    if filters[:sku]
      skus = skus.where(sku: filters[:sku])
    end

    if filters[:vendor_id]
      skus = skus.where(vendor_id: filters[:vendor_id])
    end

    if filters[:season]
      skus = skus.where(season: filters[:season])
    end

    if filters[:without_barcodes]
      skus = skus.where(barcodes: { id: nil })
    end

    skus
  end
end
