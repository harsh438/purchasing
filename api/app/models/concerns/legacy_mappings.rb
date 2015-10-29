module LegacyMappings
  extend ActiveSupport::Concern

  def as_json(options)
    map(self.class.mapped_attributes, serializable_hash)
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

      attrs.each do |new_attr, old_attr|
        legacy_fields << old_attr
        alias_attribute(new_attr, old_attr) if new_attr != old_attr
      end
    end
  end

  private

  def map(mappings, fields)
   mappings.reduce({}) do |out, (mapped, unmapped)|
      o = { mapped => fields[unmapped.to_s] }
      out.merge(o || {})
    end
  end
end
