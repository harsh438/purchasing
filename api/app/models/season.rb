class Season < ActiveRecord::Base
  include LegacyMappings

  has_many :purchase_order_line_items

  map_attributes id: :SeasonID,
                 name: :SeasonName,
                 year: :SeasonYear,
                 nickname: :SeasonNickname

  default_scope { order(sort: 'DESC') }

  def as_json(*args)
    nickname
  end
end
