module GeneralCsvValidator
  extend ActiveSupport::Concern

  included do
    def basic_valid_csv(contents, errors)
      header_line = contents[0]

      unless multiple_lines?(header_line, contents.length)
        errors[:line_count] = 'should be at least 2'
      end

      if multiple_lines?(header_line, contents.length) && number?(header_line[0])
        errors[:csv_column_header] = 'missing identifiers'
      end
    end

    private

    def multiple_lines?(header_line, contents_length)
      (header_line.is_a? Array) && contents_length > 1
    end

    def number?(string)
      true if Float(string) rescue false
    end
  end
end
