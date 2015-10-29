class Filters
  def initialize(model, params)
    @attrs = Attrs.new(model, params)
  end

  def filter(collection)
    q = @attrs.reduced
    collection.where(q).order(@attrs.order)
  end

  private

  class Attrs
    def initialize(model, params)
      @model = model
      @params = parse(params)
    end

    def filterable
      @model.filterable_fields
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

    private

    def parse(params)
      params.permit(filterable + sortable + [:page])
    end
  end
end
