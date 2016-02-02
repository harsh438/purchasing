feature 'Download supplier terms as XLSX' do
  let(:xlsx) do
    Tempfile.open('supplier_terms_test.xlsx') do |f|
      f << page.body
      f.close
      SimpleXlsxReader.open(f.path)
    end
  end
  let(:xlsx_rows) { xlsx.sheets.first.rows }
  let(:xlsx_header_row) { xlsx_rows.first }
  let(:xlsx_result_rows) { xlsx_rows.drop(1) }

  scenario 'Trying to download purchase orders XLSX without filters' do
    when_a_user_tries_to_download_xlsx_without_terms_selected
    then_they_should_see_an_error
  end

  scenario 'Downloading XLSX filtered by vendor' do
    when_a_user_downloads_xlsx_filtered_by_vendor
    then_the_xlsx_file_should_contain_only_purchase_orders_for_that_vendor
  end

  scenario 'Selecting terms to be shown in XLSX' do
    when_a_user_selects_terms_to_be_show_in_the_xlsx
    then_the_xlsx_should_show_those_fields
  end

  def when_a_user_tries_to_download_xlsx_without_terms_selected
    visit supplier_terms_path(format: :xlsx)
  end

  def then_they_should_see_an_error
    expect(page).to have_content('Please filter by terms')
  end

  def when_a_user_downloads_xlsx_filtered_by_vendor
    vendor = create(:vendor)
    create_list(:supplier_terms, 2, supplier: create(:supplier, vendors: [vendor]))
    create_list(:supplier_terms, 2, supplier: create(:supplier, vendors: [vendor]))
    url = supplier_terms_path(format: :xlsx, filters: { vendor_id: vendor.id,
                                                       default: '0',
                                                       terms: ['pre_order_discount'] })
    visit url
  end

  def then_the_xlsx_file_should_contain_only_purchase_orders_for_that_vendor
    expect(xlsx_result_rows.count).to eq(4)
  end

  def when_a_user_selects_terms_to_be_show_in_the_xlsx
    vendor = create(:vendor)
    create_list(:supplier_terms, 2, default: true)
    visit supplier_terms_path(format: :xlsx, filters: { terms: ['pre_order_discount'] })
  end

  def then_the_xlsx_should_show_those_fields
    expect(xlsx_header_row).to include('pre_order_discount'.humanize)
    expect(xlsx_header_row).to_not include('credit_limit'.humanize)
  end
end
