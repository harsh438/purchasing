FactoryGirl.define do
  factory :purchase_order do
    drop_date { Time.now }
  end
end
