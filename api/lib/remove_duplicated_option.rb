class RemoveDuplicatedOption
  def initialize(logger)
    @logger = logger
    @log_count = 0
  end

  def process!
    log_count_start("start removing duplicate options")
    dup_option_values.each do |dup_option_value|
      @dup_option_value = options_hash(dup_option_value)
      log
      p dup_option_value
      process_duplicate_values
      # log(dup_option_value)
    end
    "Removed #{@log_count} duplicate options"
  end

  def process_duplicate_values
    update_language_product_option
    update_purchase_orders
    update_skus_option_id
    remove_duplicate_lang_options
    delete_option_values
  end

  def remove_duplicate_lang_options
    return if duplicate_lang_options.count < 2
    update_skus_language_product_id(duplicate_lang_options.first.id)
    delete_lang_options_values
  end

  def duplicate_lang_options
    @duplicate_lang_options ||
    LanguageProductOption.where(language_id: 1,
                                option_id: @dup_option_value[:option_id])
                          .order(id: :desc)
  end

  def delete_lang_options
    highest_id = duplicate_lang_options.first.id
    duplicate_lang_options.reject do |lang_option|
      lang_option.id == highest_id
    end
  end

  def delete_lang_options_values
    delete_lang_options.each do |lang_option|
      LanguageProductOption.delete(lang_option.id)
    end
  end

  def delete_options
    @dup_option_value[:options].split(',').reject do |option|
      option.to_i == @dup_option_value[:option_id]
    end
  end

  def delete_option_values
    delete_options.each do |option_id|
      Option.delete(option_id.to_i)
    end
  end

  def update_language_product_option
    execute "UPDATE `ds_language_product_options` " \
      "SET `oid` = #{@dup_option_value[:option_id]} " \
      "WHERE `oid` IN (#{@dup_option_value[:options]}) " \
      "AND pid = #{@dup_option_value[:product_id]};"
  end

  def update_purchase_orders
    execute "UPDATE purchase_orders " \
    "SET oid = #{@dup_option_value[:option_id]} " \
    "WHERE oid IN (#{@dup_option_value[:options]})"
  end

  def update_skus_option_id
    execute "UPDATE skus " \
    "SET option_id = #{@dup_option_value[:option_id]} " \
    "WHERE option_id IN (#{@dup_option_value[:options]})"
  end

  def update_skus_language_product_id(language_product_id)
    execute "UPDATE skus " \
    "SET language_product_id = #{language_product_id} " \
    "WHERE option_id IN (#{@dup_option_value[:option_id]})"
  end

  def dup_option_values
    sql = "SELECT " \
             "pid as produt_id, oSizeL as size, " \
             "GROUP_CONCAT(oid) as options_list, "\
             "max(oid) as max_option_id, count(*)  as total " \
             "from " \
             "ds_options " \
             "where " \
             "pid > 0 and " \
             "oSizeL REGEXP '[^A-Za-z0-9]+' " \
             "group by pid, oSizeL "\
             "Having count(*) > 1 "\
             "limit 800; "
    execute sql
  end


  def options_hash(data)
    {
      product_id: data[0],
      size: data[1],
      options: data[2],
      option_id: data[3],
      count: data[4]
    }
  end

  def execute(query)
    ActiveRecord::Base.connection.execute(query)
  end

  def log
    log = "product_id: #{@dup_option_value[:product_id]},
           size: #{@dup_option_value[:size]},
           options: #{@dup_option_value[:options]},
           option_id: #{@dup_option_value[:option_id]},
           count: #{@dup_option_value[:count]}"
    @logger.info(log)
  end

  def log_count_start(message)
    @logger.info(message)
  end
end
