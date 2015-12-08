feature 'Download supplier terms as CSV' do
  let(:csv) { CSV.parse(page.body) }
  let(:csv_header_row) { csv.first }
  let(:csv_result_rows) { csv.drop(1) }

  scenario 'Downloading CSV filtered by vendor' do
    when_a_user_downloads_csv_filtered_by_vendor
    then_the_csv_file_should_contain_only_purchase_orders_for_that_vendor
  end

  def when_a_user_tries_to_download_csv_without_terms_selected
    visit supplier_terms_path(format: :csv)
  end

  def then_they_should_see_an_error
    expect(page).to have_content('Please select terms')
  end

  def when_a_user_downloads_csv_filtered_by_vendor
    vendor = create(:vendor)
    create_list(:supplier_terms, 2, supplier: create(:supplier, vendors: [vendor]))
    create_list(:supplier_terms, 2, supplier: create(:supplier, vendors: [vendor]))
    visit supplier_terms_path(format: :csv, filters: { vendor_id: vendor.id, default: '0' })
  end

  def then_the_csv_file_should_contain_only_purchase_orders_for_that_vendor
    expect(csv_result_rows.count).to eq(4)
  end
end
