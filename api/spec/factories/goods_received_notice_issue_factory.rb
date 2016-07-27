FactoryGirl.define do
  factory :goods_received_notice_issue do
    goods_received_notice_id { create(:goods_received_notice).id }
    issue_type :cartons_good_condition
    units_affected 5

    trait :with_images do
      transient do
        image_count 1
      end

      after(:create) do |issue, evaluator|
        create_list(:goods_received_notice_issue_image,
                    evaluator.image_count,
                    goods_received_notice_issue: issue)
      end
    end
  end
end
