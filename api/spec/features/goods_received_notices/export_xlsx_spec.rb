feature 'Download GRNs as XLSX', booking_db: true do
  scenario 'Downloading total for each  GRNs for the current month' do
    when_a_user_downloads_xlsx_of_current_month_grns
    then_the_xlsx_file_should_contain_all_grns_for_the_current_month
  end

  scenario 'Downloading current view as xlsx' do
    when_a_user_downloads_xlsx_of_current_view
    then_the_xlsx_file_should_contain_list_of_all_grn_for_current_view
  end

  def when_a_user_downloads_xlsx_of_current_month_grns
    create_grns
    visit goods_received_notices_path(format: :xlsx, type: :month, month: 2, year: 2016)
  end

  def then_the_xlsx_file_should_contain_all_grns_for_the_current_month
    expect(grn_result_rows.first.first).to eq(Date.new(2016, 2, 1).to_s)
    expect(grn_result_rows.second.first).to eq(Date.new(2016, 2, 2).to_s)

    expect(po_result_rows.first.first).to eq(Date.new(2016, 2, 1).to_s)
    expect(po_result_rows.second.first).to eq(Date.new(2016, 2, 2).to_s)
  end

  def when_a_user_downloads_xlsx_of_current_view
    create_grns
    visit goods_received_notices_path(format: :xlsx, type: :range, start_date: '2016-02-01', end_date: '2016-02-28')
  end

  def then_the_xlsx_file_should_contain_list_of_all_grn_for_current_view
    expect(grn_result_rows.first.first).to eq(Date.new(2016, 2, 1).to_s)
    expect(grn_result_rows.second.first).to eq(Date.new(2016, 2, 2).to_s)

    expect(po_result_rows.first.first).to eq(Date.new(2016, 2, 1).to_s)
    expect(po_result_rows.second.first).to eq(Date.new(2016, 2, 2).to_s)
  end

  private

  let(:xlsx) do
    Tempfile.open('goods_received_notices_test.xlsx') do |f|
      f << page.body
      f.close
      SimpleXlsxReader.open(f.path)
    end
  end

  let(:xlsx_rows) { xlsx.sheets.first.rows }

  let(:grn_header_row) { xlsx_rows.first }
  let(:grn_result_rows) { xlsx_rows.drop(1).take(2) }

  let(:po_header_row) { xlsx_rows.drop(3).first }
  let(:po_result_rows) { xlsx_rows.drop(4) }

  def create_grns
    create_list(:goods_received_notice, 3, :with_purchase_orders,
                                           delivery_date: Time.new(2015, 1, 1))

    create(:goods_received_notice,
           :with_purchase_orders,
           delivery_date: Time.new(2016, 2, 1))

    create(:goods_received_notice,
           :with_purchase_orders,
           delivery_date: Time.new(2016, 2, 2))
  end
end
