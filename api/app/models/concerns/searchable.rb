module Searchable
  extend ActiveSupport::Concern
  include LegacyMappings

  included do
    scope :mapped, -> { select(legacy_fields) }
  end

  module ClassMethods
    def filterable_fields
      @filterable_fields ||= []
    end

    def filters(*fields)
      fields.each { |field| filterable_fields << field.to_s }
    end
  end
end
