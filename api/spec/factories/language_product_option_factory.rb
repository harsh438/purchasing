FactoryGirl.define do
  factory :language_product_option do
    product
    option
    language_id 1
    sequence(:name) { |i| "o#{i}" }

    after(:build) do |language_product_option, evaluator|
      element = create(:element, elementname: language_product_option.name)
      language_product_option.element = element
    end
  end
end
