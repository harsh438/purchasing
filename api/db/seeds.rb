unless defined? FactoryGirl
  require 'faker'
  require 'factory_girl'
end

FactoryGirl.factories.clear
FactoryGirl.sequences.clear
FactoryGirl.definition_file_paths << File.join('spec', 'factories')
FactoryGirl.find_definitions

include FactoryGirl::Syntax::Methods

Season.find_or_create_by(name: 'SS', year: '2011', nickname: 'SS11', sort: 3)
Season.find_or_create_by(name: 'AW', year: '2011', nickname: 'AW11', sort: 4)
Season.find_or_create_by(name: 'SS', year: '2012', nickname: 'SS12', sort: 5)
Season.find_or_create_by(name: 'AW', year: '2012', nickname: 'AW12', sort: 6)
Season.find_or_create_by(name: 'SS', year: '2013', nickname: 'SS13', sort: 7)
Season.find_or_create_by(name: 'AW', year: '2013', nickname: 'AW13', sort: 8)
Season.find_or_create_by(name: 'SS', year: '2014', nickname: 'SS14', sort: 9)
Season.find_or_create_by(name: 'AW', year: '2014', nickname: 'AW14', sort: 10)
Season.find_or_create_by(name: 'SS', year: '2010', nickname: 'SS10', sort: 1)
Season.find_or_create_by(name: 'AW', year: '2010', nickname: 'AW10', sort: 2)
Season.find_or_create_by(name: 'CONT', year: 'CONT', nickname: 'CONT', sort: 13)
Season.find_or_create_by(name: 'SS', year: '2015', nickname: 'SS15', sort: 11)
Season.find_or_create_by(name: 'AW', year: '2015', nickname: 'AW15', sort: 12)
Season.find_or_create_by(name: 'SS', year: '2016', nickname: 'SS16', sort: 14)
Season.find_or_create_by(name: 'AW', year: '2016', nickname: 'AW16', sort: 15)
Season.find_or_create_by(name: 'SS', year: '2017', nickname: 'SS17', sort: 16)

create_list(:order, 3, line_item_count: 2)
create_list(:supplier, 5, contact_count: 2)

50.times do
  create(:goods_received_notice, :give_or_take_2_weeks,
                                 :with_purchase_orders,
                                 :with_packing_list,
                                 po_count: [1, 2, 3, 4, 5].sample)
end

create_list(:sku, 10)
