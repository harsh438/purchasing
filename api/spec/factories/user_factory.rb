FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    password '3563316662393861386636643764313661613761373835336131656535653262'
    email { Faker::Internet.email }
    active 1
    lastLoggedIn { Time.now }
    seconds 7200
    bgcolor '#888888'

    after(:build) do |user|
      user.initials = user.name.split(' ').map { |name| name[0] }.join('')
    end
  end
end
