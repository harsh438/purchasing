module LegacyMappings
  extend ActiveSupport::Concern

  def as_json(options = {})
    map(super, self.class.mapped_attributes, serializable_hash)
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

  def map(out, mappings, fields)
    mappings.reduce(out) do |out, (mapped, unmapped)|
      if fields.has_key?(unmapped.to_s)
        out.delete(unmapped.to_s)
        out.merge(mapped.to_s => fields[unmapped.to_s])
      else
        out
      end
    end
  end
end
