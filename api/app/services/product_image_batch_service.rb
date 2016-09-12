class ProductImageBatchService
  SUPPORTED_ACTIONS = %w( replace append prepend ).freeze
  ATTR_MAPPINGS = {
    position: %w( position ),
    width: %w( elasticera width ),
    height: %w( elasticera height ),
    its_reference: %w( elasticera reference ),
    source_path: %w( s3 url ),
  }.freeze

  def replace_assets(product_id, batch_id, assets)
    with_product_id(product_id) do |pid, neg|
      mark_existing_as_deleted(pid)
      create_assets(pid, neg, batch_id, assets).tap do
        touch_product(pid)
      end
    end
  end

  def append_assets(product_id, batch_id, assets)
    with_product_id(product_id) do |pid, neg|
      count = ProductImage.where(negative_aware_filter(pid))
                          .maximum(:position) || 0
      assets = assets.map do |asset|
        asset.tap { |a| a['position'] += count }
      end
      create_assets(pid, neg, batch_id, assets).tap do
        touch_product(pid)
      end
    end
  end

  def prepend_assets(product_id, batch_id, assets)
    with_product_id(product_id) do |pid, neg|
      count = assets.count
      update_positions(count, pid)
      create_assets(pid, neg, batch_id, assets).tap do
        touch_product(pid)
      end
    end
  end

  private

  def discover_product_id(known_id)
    # this is pretty hideous so let me explain
    # known id here isn't always an ID. It is sometimes a
    # negative PID. The easiest way to calculate the actual
    # PID is to find an image that has the matching reference
    # and then use the PID found on that as it is auto-updated
    # over night. So below we actually build a list of known
    # product IDs based on what the image is linked to and then
    # using this list to locate the real product.
    #
    # TLDR
    # Product.find(product_id) would be wrong in some instances
    products = Product.arel_table
    images = ProductImage.arel_table
    Product.where(
      products[:pID].in(
        images.project(images[:product_id]).where(
          negative_aware_filter(known_id)
        ).distinct
      )
    ).pluck(:id).first
  end

  def with_product_id(product_id)
    pos = discover_product_id(product_id) || product_id
    neg = product_id < 0 ? product_id : nil
    yield(pos, neg) if block_given?
  end

  def negative_aware_filter(product_id)
    t = ProductImage.arel_table
    col = product_id > 0 ? :product_id : :negative_ref
    t[col].eq(product_id)
  end

  def mark_existing_as_deleted(product_id)
    ProductImage.where(negative_aware_filter(product_id))
      .update_all(
        deleted_at: Time.current,
        accepted_at: nil,
      )
  end

  def enrich_image(image, asset)
    ATTR_MAPPINGS.each do |attr, lookup|
      image[attr] = lookup.inject(asset) { |v, key| v.fetch(key) }
    end
    image.negative_ref = image.read_attribute(:product_id) if image.read_attribute(:product_id) < 0
  end

  def create_assets(product_id, negative_pid, batch_id, assets)
    assets.map do |asset|
      ProductImage.new(
        product_id: product_id,
        import_batch_id: batch_id,
        negative_ref: negative_pid,
      ).tap do |image|
        enrich_image(image, asset)
        image.save!
      end
    end
  end

  def touch_product(product_id)
    Product.where(id: product_id).update_all(updated_at: Time.current)
  end

  def update_positions(adjustment, product_id)
    ProductImage.where(negative_aware_filter(product_id)).each do |image|
      image.update!(position: image.position + adjustment)
    end
  end
end
