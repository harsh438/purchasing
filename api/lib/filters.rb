class Filters
  def initialize(attrs)
    @attrs = attrs
  end

  def filter(collection)
    @model = collection.model
    mappings = @model.mapped_attributes
    q = map(mappings, @attrs.slice(*@model.filterable_fields))
    sort(collection.where(q))
  end

  private

  def map(mappings, fields)
   mappings.reduce({}) do |out, (mapped, unmapped)|
      o = { unmapped => fields[mapped] } if fields[mapped]
      out.merge(o || {})
    end
  end

  def sort(collection)
    if @attrs[:sort_field] and @attrs[:sort_dir]
      collection.order(@attrs[:sort_field] => @attrs[:sort_dir])
    elsif @attrs[:sort_field]
      collection.order(@attrs[:sort_field])
    else
      collection
    end
  end
end
