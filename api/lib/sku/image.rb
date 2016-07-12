class Image
  def initialize(product_image)
    @product_image = product_image
  end

  def as_json
    {
      url: url,
      position: position,
      dimensions: {
        height: height,
        width: width
      },
      elasticera_reference: elasticera_reference,
      legacy_id: legacy_id
    }
  end

  private

  attr_reader :product_image

  def url
    @url ||= "http://asset1.surfcdn.com/#{product_image.its_reference}?w=400"
  end

  def position
    @position ||= product_image.position
  end

  def height
    @height ||= product_image.height
  end

  def width
    @width ||= product_image.width
  end

  def elasticera_reference
    @reference ||= product_image.its_reference
  end

  def legacy_id
    @legacy_id ||= product_image.id
  end
end
