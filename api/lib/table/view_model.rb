module Table
  class ViewModel < Array
    def to_csv
      CSV.generate do |csv|
        reduce(csv, &:<<)
      end
    end

    def to_xlsx
      XLSX.build_single_worksheet(self).to_stream.string
    end
  end

  class XLSX
    def self.build_single_worksheet(rows)
      xlsx = Axlsx::Package.new
      wb = xlsx.workbook
      add_worksheet(wb, 'Sheet 1', rows)
      xlsx
    end

    private

    def self.add_worksheet(wb, worksheet_name, rows)
      wb.add_worksheet(name: worksheet_name.to_s.humanize) do |sheet|
        rows.each { |row| sheet.add_row(row) }
      end
    end
  end
end
