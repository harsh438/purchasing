class Search
  attr_reader :results

  def initialize(model, attrs)
    @results = Filters.new(model, attrs).filter(model.mapped).page(attrs[:page])
  end
end
