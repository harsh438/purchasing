class Search
  attr_reader :filters
  attr_reader :results

  def initialize(model, attrs)
    @filters = Filters.new(model, attrs)
    @results = filters.filter(model.mapped).page(attrs[:page])
  end
end
