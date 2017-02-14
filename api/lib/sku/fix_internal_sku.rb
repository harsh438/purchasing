class Sku::FixInternalSku
  def initialize(logger)
    @logger = logger
    @log_count = 0
  end

  def process!
    log_count_start("start updating internal sku")
    find_incorrect_internal_skus.each do |incorrect_internal_skus|
      @internal_sku = internal_sku_hash(incorrect_internal_skus)
      # binding.pry
      element_id = get_element(incorrect_internal_skus[5])
      # binding.pry
      next if element_id.nil?
      process_internal_sku
    end
    "updated #{@log_count} internal sku"
  end

  def process_internal_sku
    update_internal_sku
    update_option_size
    update_language_product_options
    update_pvx_in_po
  end

  def get_element(size)
    Element.where(name: size).pluck(:id)[0]
  end

  def build_internal_sku(product_id, size)
    element_id = get_element(size)
    "#{product_id}-#{element_id}"
  end

  def update_internal_sku
    Sku.find(@internal_sku[:sku_id]).update_attributes(sku_attributes)
  end

  def update_option_size
    Option.find(@internal_sku[:option_id])
          .update_attribute(:size, @internal_sku[:size])
  end

  def update_language_product_options
    LanguageProductOption.find_by(language_id: 1,
                                option_id: @internal_sku[:option_id])
                         .update_attributes(product_option_attributes)
  end

  def update_pvx_in_po
    pvx_in_po = PvxInPo.find_by(sku: @internal_sku[:from_sku])
    return if pvx_in_po.nil?
    pvx_in_po.update_column(:sku, @internal_sku[:new_internal_sku])
  end

  def internal_sku_hash(data)
    {
      sku_id: data[0],
      from_sku: data[1],
      size: data[5],
      product_id: data[2],
      old_element_id: data[3],
      option_id: data[4],
      new_element_id: get_element(data[5]),
      new_internal_sku: build_internal_sku(data[2], data[5])
    }
  end

  def sku_attributes
    {
      sku: @internal_sku[:new_internal_sku],
      element_id: @internal_sku[:new_element_id]
    }
  end

  def product_option_attributes
    {
      element_id: @internal_sku[:new_element_id],
      name: @internal_sku[:size]
    }
  end

  def find_incorrect_internal_skus
    sql = "SELECT " \
            "id, " \
            "sku, " \
            "product_id, " \
            "elementID, " \
            "option_id, " \
            "size, " \
            "e.elementID, " \
            "e.elementname " \
          "FROM " \
            "skus s " \
            "join " \
            "mnp_elements e on s.element_id = e.elementID and s.size != e.elementname " \
          "WHERE " \
            "s.inv_track ='O' "
    p sql
    execute sql
  end

  def execute(query)
    ActiveRecord::Base.connection.execute(query)
  end

  def log_count_start(message)
    @logger.info(message)
  end
end
