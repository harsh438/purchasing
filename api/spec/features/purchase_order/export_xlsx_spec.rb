feature 'Download purchase order as XLSX' do
  scenario 'Downloading Purchase Orders' do
    when_a_user_downloads_csv_summary_of_purchase_order
    then_the_csv_file_should_contain_a_summary_of_that_purchase_order
  end

  def when_a_user_downloads_csv_summary_of_purchase_order
    visit purchase_order_path(purchase_order, format: :xlsx)
  end

  def then_the_csv_file_should_contain_a_summary_of_that_purchase_order
    expect(xlsx_order_number).to include(purchase_order.id.to_s)
    expect(xlsx_delivery_date).to include(purchase_order.drop_date.to_s)
    expect(xlsx_result_rows.last).to include('TOTALS')
    expect(xlsx_result_rows.last[7].to_i).to be(purchase_order.quantity.to_i)
    expect(xlsx_result_rows.last[10].to_i).to be(purchase_order.total.to_i)
  end

  let(:purchase_order) { create(:purchase_order, :with_line_items) }
  let(:xlsx) do
    Tempfile.open('purchase_order_test.xlsx') do |f|
      f << page.body
      f.close
      SimpleXlsxReader.open(f.path)
    end
  end

  let(:xlsx_rows) { xlsx.sheets.first.rows }
  let(:xlsx_order_number) { xlsx_rows.first.first }
  let(:xlsx_delivery_date) { xlsx_rows.first.third }
  let(:xlsx_header_row) { xlsx_rows.third }
  let(:xlsx_result_rows) { xlsx_rows.drop(3) }
end
