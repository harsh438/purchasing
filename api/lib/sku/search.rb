class Sku::Search
  def search(params)
    skus = Sku.latest.includes(:vendor, :language_category)
    skus = apply_filters(skus, params[:filters] || {})
    skus = skus.page(params[:page])
    skus
  end

  private

  def apply_filters(skus, filters)
    if filters[:sku]
      skus = skus.where(sku: filters[:sku])
    end

    skus
  end
end
