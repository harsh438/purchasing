require 'factory_girl'
FactoryGirl.definition_file_paths << File.join('spec', 'factories')
FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods

create_list(:order, 3)
