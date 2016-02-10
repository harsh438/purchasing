class SupplierTerms::Exporter
  class NoTermsSelectedError < RuntimeError; end

  CSV_COLUMNS = %w(supplier_name
                   brand_name
                   created_at
                   confirmed?
                   default?)

  def export(params)
    if params[:filters].blank? or params[:filters][:terms].blank? or params[:filters][:terms].empty?
      raise NoTermsSelectedError
    end

    supplier_terms = SupplierTerms.latest.includes(:supplier)
    supplier_terms = SupplierTerms::Filter.new.apply(supplier_terms, params[:filters] || {})

    columns = csv_columns(params[:filters][:terms])

    csv = Table::ViewModel.new
    csv << columns.map(&:humanize)
    supplier_terms.each do |terms|
        csv << column_values(terms, columns)
    end
    csv
  end

  private

  def csv_columns(terms_selected)
    allowed_terms = SupplierTerms.stored_attributes[:terms].map(&:to_s)

    if terms_selected.respond_to?(:values)
      valid_terms_selected = allowed_terms & terms_selected.values
    else
      valid_terms_selected = allowed_terms & terms_selected.to_a
    end

    CSV_COLUMNS + valid_terms_selected
  end

  def column_values(terms, columns)
    columns.map { |method| terms.send(method) }
  end
end
