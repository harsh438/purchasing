class Filters
  def initialize(model, params)
    @attrs = Attrs.new(model, params)
  end

  def filter(collection)
    scoped = @attrs.scope(collection)
    query = @attrs.reduced
    scoped.where(query).order(@attrs.order)
  end

  private

  class Attrs
    def initialize(model, params)
      @model = model
      @params = params
    end

    def scope(collection)
      scopable.reduce(collection) do |collection, (key, values)|
        scope = "filter_#{key}"
        if collection.respond_to?(scope)
          collection.send(scope, values)
        else
          collection
        end
      end
    end

    def filterable
      @model.filterable_fields
    end

    def scopable
      @params.except(*filterable)
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
