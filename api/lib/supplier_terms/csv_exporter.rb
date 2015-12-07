class SupplierTerms::CsvExporter
  CSV_ATTRIBUTES =  SupplierTerms.column_names.reject { |a| a == 'terms' }
  CSV_COLUMNS = CSV_ATTRIBUTES + SupplierTerms.termslist

  def export(params)
    supplierTerms = SupplierTerms::Search.new.search(params)
    CSV.generate do |csv|
      csv << CSV_COLUMNS.map(&:to_s).map(&:humanize)
      supplierTerms.each do |term|
        csv << term.attributes.values_at(*CSV_ATTRIBUTES) + term.terms.values_at(*SupplierTerms.termslist)
      end
    end
  end
end
