feature 'Sku Exporting' do
  scenario 'Exporting CSV for specific Order' do
    when_exporting_skus_for_an_order
    then_i_should_receive_all_skus_in_that_order
  end

  scenario 'Exporting CSV for specific Purchase Order' do
    when_exporting_skus_for_a_purchase_order
    then_i_should_receive_all_skus_in_that_purchase_order
  end

  scenario 'Exporting brand specific SKU summary CSV' do
    when_exporting_skus_for_filter_terms_as_csv
    then_the_csv_should_contain_all_skus_that_match_the_filter_terms
  end

  scenario 'Exporting brand specific SKU summary XLSX' do
    when_exporting_skus_for_filter_terms_as_xlsx
    then_the_xlsx_should_contain_all_skus_that_match_the_filter_terms
  end

  def when_exporting_skus_for_an_order
    create_order
    visit skus_path(format: :csv, order_id: order.id)
  end

  def then_i_should_receive_all_skus_in_that_order
    expect(csv_result_rows.count).to eq(skus.count)
    expected_internal_skus = skus.map(&:sku)

    csv_result_rows.map(&:first).each do |internal_sku|
      expect(expected_internal_skus).to include(internal_sku)
    end
  end

  def when_exporting_skus_for_a_purchase_order
    create_purchase_order
    visit skus_path(format: :csv, purchase_order_id: po.id)
  end

  def then_i_should_receive_all_skus_in_that_purchase_order
    expect(csv_result_rows.count).to eq(skus.count)
  end

  def when_exporting_skus_for_filter_terms_as_csv
    visit supplier_summary_skus_path(format: :csv, filters: { vendor_id: skus.first.vendor_id })
  end

  def then_the_csv_should_contain_all_skus_that_match_the_filter_terms
    expect(csv_result_rows.length).to be(1)
    expect(csv_result_rows.first).to include(skus.first.sku)
  end

  def when_exporting_skus_for_filter_terms_as_xlsx
    visit supplier_summary_skus_path(format: :xlsx, filters: { vendor_id: skus.first.vendor_id })
  end

  def then_the_xlsx_should_contain_all_skus_that_match_the_filter_terms
    expect(xlsx_result_rows.length).to be(1)
    expect(xlsx_result_rows.first).to include(skus.first.sku)
  end

  let(:order) { create(:order) }

  let(:order_line_items) do
    skus.each do |sku|
      create(:order_line_item, order: order, internal_sku: sku.sku)
    end

    order.exports.create!(purchase_order: po)
  end
  alias_method :create_order, :order_line_items

  let(:po) { create(:purchase_order) }

  let(:skus) do
    create_list(:sku, 5, :with_purchase_order_line_item, purchase_order: po)
  end
  alias_method :create_purchase_order, :skus

  let(:csv) { CSV.parse(page.body) }
  let(:csv_header_row) { csv.first }
  let(:csv_result_rows) { csv.drop(1) }

  let(:xlsx) do
    Tempfile.open('test.xlsx') do |f|
      f << page.body
      f.close
      SimpleXlsxReader.open(f.path)
    end
  end
  let(:xlsx_header_row) { xlsx.sheets.first.rows.first }
  let(:xlsx_result_rows) { xlsx.sheets.first.rows.drop(1) }
end
