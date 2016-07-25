feature 'Download GRNs as XLSX', booking_db: true do
  scenario 'Downloading total for each  GRNs for the current month' do
    when_a_user_downloads_xlsx_of_current_month_grns
    then_the_xlsx_file_should_contain_all_grns_for_the_current_month
  end

  scenario 'Downloading current view as xlsx' do
    when_a_user_downloads_xlsx_of_current_view
    then_the_xlsx_file_should_contain_list_of_all_grn_for_current_view
  end

  scenario 'Downloading total for each  GRNs for today' do
    when_a_user_downloads_xlsx_of_todays_grns
    then_the_xlsx_file_should_contain_all_grns_for_the_current_day
  end

  def when_a_user_downloads_xlsx_of_todays_grns
    create_grns
    visit goods_received_notices_path(format: :xlsx, type: :date, date: '2016-02-01')
  end

  def when_a_user_downloads_xlsx_of_current_month_grns
    create_grns
    visit goods_received_notices_path(format: :xlsx, type: :month, month: 2, year: 2016)
  end

  def then_the_xlsx_file_should_contain_all_grns_for_the_current_month
    assert_valid_rows
  end

  def then_the_xlsx_file_should_contain_all_grns_for_the_current_day
    assert_valid_row
  end

  def when_a_user_downloads_xlsx_of_current_view
    create_grns
    visit goods_received_notices_path(format: :xlsx, type: :range, start_date: '2016-02-01', end_date: '2016-02-28')
  end

  def then_the_xlsx_file_should_contain_list_of_all_grn_for_current_view
    assert_valid_rows
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

  let(:grn_all_results) { xlsx_rows.drop(1).take_while { |row| row.first.is_a?(Numeric) } }

  let(:po_header_row) { xlsx_rows.drop(3).first }
  let(:po_result_rows) { xlsx_rows.drop(4) }

  def create_grns
    create_list(:goods_received_notice, 3, :with_purchase_orders,
                                           delivery_date: Time.new(2015, 1, 1))

    create(:goods_received_notice,
           :with_purchase_orders,
           delivery_date: Time.new(2016, 2, 1),
           po_count: 2)

    create(:goods_received_notice,
           :with_purchase_orders,
           delivery_date: Time.new(2016, 2, 2),
           po_count: 2)
  end

  def assert_valid_rows
    expect(grn_result_rows.first.second).to eq(Date.new(2016, 2, 1).to_s)
    expect(grn_result_rows.first.third).to eq(20.0)
    expect(grn_result_rows.second.second).to eq(Date.new(2016, 2, 2).to_s)
    expect(grn_result_rows.second.third).to eq(20.0)

    expect(po_result_rows.first.second).to eq(Date.new(2016, 2, 1).to_s)
    expect(po_result_rows.second.second).to eq(Date.new(2016, 2, 1).to_s)
    expect(po_result_rows.third.second).to eq(Date.new(2016, 2, 2).to_s)
    expect(po_result_rows.fourth.second).to eq(Date.new(2016, 2, 2).to_s)
    expect(po_result_rows.first[11]).to eq('AW15')
    expect(po_result_rows.first[12]).to eq(20)
  end

  def assert_valid_row
    expect(grn_result_rows.first.second).to eq(Date.new(2016, 2, 1).to_s)
    expect(grn_result_rows.first.third).to eq(20.0)
    expect(grn_all_results.count).to eq 1
  end
end
