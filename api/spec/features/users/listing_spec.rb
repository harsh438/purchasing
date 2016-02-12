feature 'Listing users' do
  subject { JSON.parse(page.body) }

  scenario 'Listing out all users' do
    when_listing_all_users
    then_only_active_users_should_be_listed
  end

  def when_listing_all_users
    create_users
    visit users_path
  end

  def then_only_active_users_should_be_listed
    expect(subject.count).to eq(4)
  end

  private

  def create_users
    create_list(:user, 4)
    create_list(:user, 2, active: 0)
  end
end
