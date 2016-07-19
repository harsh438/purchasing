class ContentSerializer < ActiveModel::Serializer
  attributes :lang, :content

  private

  def lang
    object.language_id
  end

  def content
    {
      name: object.name,
      legacy_slug: object.name_processed,
      teaser: object.teaser
    }
  end

  def name_processed
    object.name.downcase.tr(' ', '_')
      .tr("'", "") + "-#{object.product_id}"
  end
end
