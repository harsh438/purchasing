FactoryGirl.define do
  factory :packing_list do
    list File.open(Rails.root.join('spec/fixtures/files/1x1.jpg'), 'rb')
  end
end
