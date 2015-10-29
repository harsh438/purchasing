class Filters
  def initialize(attrs)
    @attrs = attrs
  end

  def filter(collection)
    @model = collection.model
    mappings = @model.mapped_attributes
    q = map(mappings, @attrs.slice(*@model.filterable_fields))
    return collection.where(q)
  end

  private

  def map(mappings, fields)
   mappings.reduce({}) do |out, (mapped, unmapped)|
      o = { unmapped => fields[mapped] } if fields[mapped]
      out.merge(o || {})
    end
  end
end
