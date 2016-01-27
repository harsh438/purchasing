class Table::ViewModel < Array
  def to_csv
    CSV.generate do |csv|
      reduce(csv, &:<<)
    end
  end
end
