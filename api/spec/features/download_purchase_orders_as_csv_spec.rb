feature 'Download purchase orders as CSV' do
  subject { CSV.parse(page.body) }
  let (:vendor) { create(:vendor) }

  before(:each) do
    create_list(:purchase_order, 20,
                status: 4,
                season: 'AW15',
                created_at: Time.new(2013, 1, 1))
    create_list(:purchase_order, 16, :arrived,
                season: 'SS14',
                created_at: Time.new(2011, 1, 1))
    create_list(:purchase_order, 15,
                vendor: vendor,
                status: -1,
                season: 'SS15',
                created_at: Time.new(2014, 1, 1))
  end

  scenario 'Trying to download purchase orders CSV without filters' do
    when_a_user_tries_to_download_csv_without_filters
    then_they_should_see_an_error
  end

  def when_a_user_tries_to_download_csv_without_filters
    visit '/api/purchase_orders.csv'
  end

  def then_they_should_see_an_error
    expect(page).to have_content('Please select filters')
  end
end
