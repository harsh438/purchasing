class Images
  def initialize(sku)
    @sku = sku
    @product_images = sku.product_images
  end

  def as_json
    product_images.map{|image| get_image(image) }[0]
  end

  def get_image(image)
    {
      url: url(image),
      position: position(image),
      dimensions: {
        height: height(image),
        width: width(image)
      },
      elasticera_reference: elasticera_reference(image),
      legacy_id: legacy_id(image)
    }
  end

  private

  attr_reader :sku, :product_images

  def url(image)
    "http://asset1.surfcdn.com/#{image.its_reference}?w=400"
  end

  def position(image)
    image.position
  end

  def height(image)
    image.height
  end

  def width(image)
    image.width
  end

  def elasticera_reference(image)
    image.its_reference
  end

  def legacy_id(image)
    image.id
  end
end

