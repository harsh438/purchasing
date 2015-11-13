FactoryGirl.define do
  factory :product do

    # required defaults
    pSale 0

    vendor_id { create(:vendor).id }
  end
end
