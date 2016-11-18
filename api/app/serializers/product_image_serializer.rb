class ProductImageSerializer < ActiveModel::Serializer
  attributes :url, :position, :dimensions, :elasticera_reference,
             :legacy_id, :s3_path

  private

  def url
    "http://asset1.surfcdn.com/#{object.its_reference}?w=400"
  end

  def dimensions
    {
      height: object.height,
      width: object.width
    }
  end

  def elasticera_reference
    object.its_reference
  end

  def legacy_id
    object.id
  end
end
