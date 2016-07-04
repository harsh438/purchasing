FactoryGirl.define do
  factory :product_gender do
    product
    gender { %w( M W U B G K C D T E F I ).sample }
  end
end
