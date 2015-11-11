FactoryGirl.define do
  factory :language_product_option do
    langID 1
    elementID 1
    pOption { Faker::Name }

    after(:create) do |language_product_option, evaluator|
      element = create(:element, elementname: language_product_option.pOption)
      language_product_option.update_attributes(elementID: element.elementID)
    end
  end
end