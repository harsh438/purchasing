class ContentSerializer < ActiveModel::Serializer
  attributes :lang, :content

  private

  LANGUAGE_MAP = {
                   1 => 'en',
                   2 => 'de',
                   3 => 'fr'
                 }

  def lang
    LANGUAGE_MAP.fetch(object.language_id)
  end

  def content
    {
      name: object.name,
      legacy_slug: name_slugged,
      teaser: object.teaser
    }
  end

  def name_slugged
    object.name.downcase.tr(' ', '_')
      .tr(?', '') + "-#{object.product_id}"
  end
end
