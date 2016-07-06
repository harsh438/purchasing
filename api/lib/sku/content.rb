class Content

  def initialize(language_product)
    @language_product = language_product
  end

  def as_json
    {
      lang: lang,
      content: {
       name: name,
       legacy_slug: legacy_slug,
       teaser: teaser
      }
    }
  end

  private

  attr_reader :language_product

  def lang
    @langid ||= language_product.langID
  end

  def name
    @name ||= language_product.pName
  end

  def legacy_slug
    @slug ||= language_product.pName.downcase.tr(' ', '_').tr("'", "") + "-#{language_product.pID}"
  end

  def teaser
    @teaser ||= language_product.pTeaser
  end
end
