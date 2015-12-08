class SupplierTerms::CsvExporter
  class NoTermsSelectedError < RuntimeError; end

  CSV_COLUMNS = %w(supplier_name
                   created_at
                   confirmed?
                   default?) + SupplierTerms.stored_attributes[:terms].map(&:to_s)

  def export(params)
    if params[:filters].blank? or params[:filters][:terms].blank? or params[:filters][:terms].empty?
      raise NoTermsSelectedError
    end

    supplier_terms = SupplierTerms.latest.includes(:supplier)
    supplier_terms = SupplierTerms::Filter.new.apply(supplier_terms, params[:filters] || {})

    CSV.generate do |csv|
      csv << CSV_COLUMNS.map(&:humanize)

      supplier_terms.each do |terms|
        csv << column_values(terms)
      end
    end
  end

  private

  def column_values(terms)
    CSV_COLUMNS.map { |method| terms.send(method) }
  end
end
