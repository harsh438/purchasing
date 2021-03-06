feature 'Download purchase orders as CSV' do
  let(:csv) { CSV.parse(page.body) }
  let(:csv_header_row) { csv.first }
  let(:csv_result_rows) { csv.drop(1) }

  let (:vendor) { create(:vendor) }

  before(:each) do
    create_purchase_orders
  end

  scenario 'Trying to download purchase orders CSV without filters' do
    when_a_user_tries_to_download_csv_without_filters
    then_they_should_see_an_error
  end

  scenario 'Downloading CSV filtered by vendor' do
    when_a_user_downloads_csv_filtered_by_vendor
    then_the_csv_file_should_contain_only_purchase_orders_for_that_vendor
  end

  scenario 'Downloaded CSV data should not be paginated' do
    given_there_are_more_than_50_results
    when_a_user_downloads_csv_that_matches_more_than_50_results
    then_the_csv_file_should_contain_more_than_50_results
  end

  scenario 'Specify fields to be included' do
    when_the_fields_are_specified
    then_the_export_should_only_include_the_specified_fields
  end

  def when_a_user_tries_to_download_csv_without_filters
    visit purchase_order_line_items_path(format: :csv)
  end

  def then_they_should_see_an_error
    expect(page).to have_content('Please select filters')
  end

  def when_a_user_downloads_csv_filtered_by_vendor
    visit purchase_order_line_items_path(format: :csv, vendor_id: vendor.id)
  end

  def then_the_csv_file_should_contain_only_purchase_orders_for_that_vendor
    expect(csv_result_rows.count).to eq(15)

    index = csv_header_row.find_index { |row| row == 'Product name' }

    csv_result_rows.each do |row|
      expect(row[index]).to include(vendor.name)
    end
  end

  def given_there_are_more_than_50_results
    create_list(:purchase_order_line_item,
                60,
                :with_summary,
                vendor: vendor,
                status: -1,
                season: 'SS15',
                product_name: "#{vendor.name} item",
                created_at: Time.new(2014, 1, 1))
  end

  def when_a_user_downloads_csv_that_matches_more_than_50_results
    visit purchase_order_line_items_path(format: :csv, vendor_id: vendor.id)
  end

  def then_the_csv_file_should_contain_more_than_50_results
    expect(csv_result_rows.count).to be > 50
  end

  def when_the_fields_are_specified
    visit purchase_order_line_items_path(format: :csv,
                                         vendor_id: vendor.id,
                                         columns: [
                                           :product_sku,
                                           :ordered_quantity,
                                           :ordered_cost
                                         ])
  end

  def then_the_export_should_only_include_the_specified_fields
    expect(csv_result_rows.first.length).to be(3)
  end

  private

  def create_purchase_orders
    create_list(:purchase_order_line_item,
                20,
                :with_summary,
                status: 4,
                season: 'AW15',
                created_at: Time.new(2013, 1, 1))

    create_list(:purchase_order_line_item,
                16,
                :with_summary,
                :arrived,
                season: 'SS14',
                created_at: Time.new(2011, 1, 1))

    create_list(:purchase_order_line_item,
                15,
                :with_summary,
                vendor: vendor,
                status: -1,
                season: 'SS15',
                product_name: "#{vendor.name} item",
                created_at: Time.new(2014, 1, 1))
  end
end
