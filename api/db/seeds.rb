require 'ffaker'
require 'factory_girl'
FactoryGirl.definition_file_paths << File.join('spec', 'factories')
FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods

create_list(:order, 3, line_item_count: 2)
create_list(:supplier, 5, contact_count: 2)

50.times do
  create(:goods_received_notice, :give_or_take_2_weeks,
                                 :with_purchase_orders,
                                 :with_purchase_list,
                                 po_count: [1, 2, 3, 4, 5].sample)
end

create_list(:sku, 10)
