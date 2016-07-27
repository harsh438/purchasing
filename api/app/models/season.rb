class Season < ActiveRecord::Base
  include LegacyMappings

  map_attributes id: :SeasonID,
                 name: :SeasonName,
                 year: :SeasonYear,
                 nickname: :SeasonNickname

  default_scope { order(sort: 'DESC') }

  def as_json(*args)
    nickname
  end
end
