class Filters
  def initialize(model, params)
    @attrs = Attrs.new(model, params)
  end

  def filter(collection)
    scoped = @attrs.scope(collection)
    scoped.where(@attrs.reduced).order(@attrs.order)
  end

  def has_filters?(collection)
    !@attrs.reduced.empty? or !@attrs.scopable(collection).empty?
  end

  private

  class Attrs
    def initialize(model, params)
      @model = model
      @params = params
    end

    def scope(collection)
      scopable(collection).reduce(collection) do |collection, (key, values)|
        collection.send("filter_#{key}", scopable(collection))
      end
    end

    def filterable
      @model.filterable_fields
    end

    def scopable(collection)
      @params.except(*filterable).keep_if do |(key, values)|
        collection.respond_to?("filter_#{key}")
      end
    end

    def filtered
      @params.slice(*filterable)
    end

    def sortable
      [:sort_field, :sort_dir]
    end

    def mappings
      @model.mapped_attributes
    end

    def reduced
      mappings.reduce({}) do |out, (mapped, unmapped)|
        o = { unmapped => filtered[mapped] } if filtered[mapped]
        out.merge(o || {})
      end
    end

    def order
      if @params[:sort_field] and @params[:sort_dir]
        { @params[:sort_field] => @params[:sort_dir] }
      elsif @params[:sort_field]
        @params[:sort_field]
      end
    end
  end
end
