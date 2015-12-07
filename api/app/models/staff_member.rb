class StaffMember < ActiveRecord::Base
  self.table_name = 'manage'

  include LegacyMappings

  map_attributes name: :Name

  def self.names
    all.order(name: :asc).map { |member| { name: member.name } }
  end
end
