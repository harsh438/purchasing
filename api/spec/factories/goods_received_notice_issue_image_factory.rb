FactoryGirl.define do
  factory :goods_received_notice_issue_image do
    image { File.new(Rails.root.join('spec', 'fixtures', 'files', '1x1.jpg')) }
  end
end
