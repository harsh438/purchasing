unless defined? FactoryGirl
  require 'faker'
  require 'factory_girl'
end

FactoryGirl.factories.clear
FactoryGirl.sequences.clear
FactoryGirl.definition_file_paths << File.join('spec', 'factories')
FactoryGirl.find_definitions

include FactoryGirl::Syntax::Methods

Season.create!(SeasonName: 'DEAD', SeasonYear: 'DEAD', SeasonNickname: 'DEAD', sort: -1)

[
  { SeasonName: 'SS',   SeasonYear: '2006', SeasonNickname: 'SS06' },
  { SeasonName: 'AW',   SeasonYear: '2006', SeasonNickname: 'AW06' },
  { SeasonName: 'SS',   SeasonYear: '2007', SeasonNickname: 'SS07' },
  { SeasonName: 'AW',   SeasonYear: '2007', SeasonNickname: 'AW07' },
  { SeasonName: 'SS',   SeasonYear: '2008', SeasonNickname: 'SS08' },
  { SeasonName: 'AW',   SeasonYear: '2008', SeasonNickname: 'AW08' },
  { SeasonName: 'SS',   SeasonYear: '2009', SeasonNickname: 'SS09' },
  { SeasonName: 'AW',   SeasonYear: '2009', SeasonNickname: 'AW09' },
  { SeasonName: 'SS',   SeasonYear: '2010', SeasonNickname: 'SS10' },
  { SeasonName: 'AW',   SeasonYear: '2010', SeasonNickname: 'AW10' },
  { SeasonName: 'SS',   SeasonYear: '2011', SeasonNickname: 'SS11' },
  { SeasonName: 'AW',   SeasonYear: '2011', SeasonNickname: 'AW11' },
  { SeasonName: 'SS',   SeasonYear: '2012', SeasonNickname: 'SS12' },
  { SeasonName: 'AW',   SeasonYear: '2012', SeasonNickname: 'AW12' },
  { SeasonName: 'SS',   SeasonYear: '2013', SeasonNickname: 'SS13' },
  { SeasonName: 'AW',   SeasonYear: '2013', SeasonNickname: 'AW13' },
  { SeasonName: 'SS',   SeasonYear: '2014', SeasonNickname: 'SS14' },
  { SeasonName: 'AW',   SeasonYear: '2014', SeasonNickname: 'AW14' },
  { SeasonName: 'SS',   SeasonYear: '2015', SeasonNickname: 'SS15' },
  { SeasonName: 'AW',   SeasonYear: '2015', SeasonNickname: 'AW15' },
  { SeasonName: 'CONT', SeasonYear: 'CONT', SeasonNickname: 'CONT' },
  { SeasonName: 'SS',   SeasonYear: '2016', SeasonNickname: 'SS16' },
  { SeasonName: 'AW',   SeasonYear: '2016', SeasonNickname: 'AW16' },
  { SeasonName: 'SS',   SeasonYear: '2017', SeasonNickname: 'SS17' },
  { SeasonName: 'AW',   SeasonYear: '2017', SeasonNickname: 'AW17' },
].each_with_index do |season, i|
  Season.find_or_create_by!(season.merge(sort: i + 1))
end

create_list(:order, 3, line_item_count: 2)
create_list(:supplier, 5, contact_count: 2)

50.times do
  create(:goods_received_notice, :give_or_take_2_weeks,
                                 :with_purchase_orders,
                                 :with_packing_list,
                                 po_count: [1, 2, 3, 4, 5].sample)
end

create_list(:sku, 10)
