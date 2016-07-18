class ProductImageSerializer < ActiveModel::Serializer
  attributes :url, :position, :dimensions, :elasticera_reference,
             :legacy_id

  private

  def url
    "http://asset1.surfcdn.com/#{image.its_reference}?w=400"
  end

  def position
    {
      height: height,
      width: width
    }
  end

  def height
    image.height
  end

  def width
    image.width
  end

  def elasticera_reference
    image.its_reference
  end

  def legacy_id
    image.id
  end
end

