module LegacyMappings
  extend ActiveSupport::Concern

  included do
    default_scope -> { select(legacy_fields) }
  end

  def as_json(options)
    Hash[*self.class.mapped_attributes.values.zip(serializable_hash.values).flatten]
  end

  module ClassMethods
    def mapped_attributes
      @mapped_attributes ||= {}
    end

    def legacy_fields
      @legacy_fields ||= []
    end

    def map_attributes(attrs)
      mapped_attributes.merge!(attrs)

      attrs.each do |key, field|
        legacy_fields << key
        alias_attribute(field, key) if key != field
      end
    end
  end
end
