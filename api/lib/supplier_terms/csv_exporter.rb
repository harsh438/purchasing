class SupplierTerms::CsvExporter
  class NoTermsSelectedError < RuntimeError; end

  CSV_COLUMNS = %w(supplier_name
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

    CSV.generate do |csv|
      csv << columns.map(&:humanize)

      supplier_terms.each do |terms|
        csv << column_values(terms, columns)
      end
    end
  end

  private

  def csv_columns(terms_selected)
    valid_terms_selected = SupplierTerms.stored_attributes[:terms].map(&:to_s) & terms_selected
    CSV_COLUMNS + valid_terms_selected
  end

  def column_values(terms, columns)
    columns.map { |method| terms.send(method) }
  end
end
