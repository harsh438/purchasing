class Search
  attr_reader :filters

  def initialize(model, attrs)
    @model = model
    @attrs = attrs
    @filters = Filters.new(model, attrs)
  end

  def unpaginated_results
    filters.filter(@model.mapped)
  end

  def results
    unpaginated_results.page(@attrs[:page])
  end
end
