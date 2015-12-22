feature 'Download purchase order as CSV' do
  scenario 'Downloading Purchase Orders' do
    when_a_user_downloads_csv_summary_of_purchase_order
    then_the_csv_file_should_contain_a_summary_of_that_purchase_order
  end

  def when_a_user_downloads_csv_summary_of_purchase_order
    visit purchase_order_path(purchase_order, format: :csv)
  end

  def then_the_csv_file_should_contain_a_summary_of_that_purchase_order
    expect(csv_order_number).to include(purchase_order.id.to_s)
    expect(csv_delivery_date).to include(purchase_order.drop_date.to_s)
    expect(csv_result_rows.last).to include('TOTALS')
    expect(csv_result_rows.last).to include(purchase_order.quantity.to_s)
    expect(csv_result_rows.last).to include(purchase_order.total.to_s)
  end

  let(:purchase_order) { create(:purchase_order, :with_line_items) }
  let(:csv) { CSV.parse(page.body) }
  let(:csv_order_number) { csv.first.first }
  let(:csv_delivery_date) { csv.first.third }
  let(:csv_header_row) { csv.third }
  let(:csv_result_rows) { csv.drop(3) }
end
