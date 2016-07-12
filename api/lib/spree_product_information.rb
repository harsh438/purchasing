class SpreeProductInformation

  def initlaize(params)
    @params = params
  end

  def as_json
    {
      children: params[:children],
      options: options,
    }
  end

  private

  attr_reader :params

  def options
    return [] if params[:children].empty?
    "Size"
  end
end
