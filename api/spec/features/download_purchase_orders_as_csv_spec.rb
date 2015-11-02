feature 'Download purchase orders as CSV' do
  let(:csv) { CSV.parse(page.body) }
  let(:csv_header_row) { csv.first }
  let(:csv_result_rows) { csv.drop(1) }

  let (:vendor) { create(:vendor) }

  before(:each) do
    create_list(:purchase_order, 20, status: 4,
                                     season: 'AW15',
                                     created_at: Time.new(2013, 1, 1))

    create_list(:purchase_order, 16, :arrived, season: 'SS14',
                                               created_at: Time.new(2011, 1, 1))

    create_list(:purchase_order, 15, vendor: vendor,
                                     status: -1,
                                     season: 'SS15',
                                     product_name: "#{vendor.name} item",
                                     created_at: Time.new(2014, 1, 1))
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

  def when_a_user_tries_to_download_csv_without_filters
    visit '/api/purchase_orders.csv'
  end

  def then_they_should_see_an_error
    expect(page).to have_content('Please select filters')
  end

  def when_a_user_downloads_csv_filtered_by_vendor
    visit "/api/purchase_orders.csv?vendor_id=#{vendor.id}"
  end

  def then_the_csv_file_should_contain_only_purchase_orders_for_that_vendor
    expect(csv_result_rows.count).to eq(15)

    index = csv_header_row.find_index { |row| row == 'product_name' }

    csv_result_rows.each do |row|
      expect(row[index]).to include(vendor.name)
    end
  end

  def given_there_are_more_than_50_results
    create_list(:purchase_order, 60, vendor: vendor,
                                     status: -1,
                                     season: 'SS15',
                                     product_name: "#{vendor.name} item",
                                     created_at: Time.new(2014, 1, 1))
  end

  def when_a_user_downloads_csv_that_matches_more_than_50_results
    visit "/api/purchase_orders.csv?vendor_id=#{vendor.id}"
  end

  def then_the_csv_file_should_contain_more_than_50_results
    expect(csv_result_rows.count).to be > 50
  end
end
