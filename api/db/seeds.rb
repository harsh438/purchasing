require 'ffaker'
require 'factory_girl'
FactoryGirl.definition_file_paths << File.join('spec', 'factories')
FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods

create_list(:order, 3, line_item_count: 2)
create_list(:supplier, 5, contact_count: 2)
create_list(:goods_received_notice, 50, :give_or_take_2_weeks)
