class GoodsReceivedNotice::Attachments < Struct.new(:goods_received_notice)
  def urls
    [].concat(legacy_urls).concat(current_urls)
  end

  def delete_by_url(url)
    if legacy_url?(url)
      delete_legacy_url(url)
    elsif current_url?(url)
      delete_current_url(url)
    end
  end

  private

  def legacy_url(filename)
    "https://www.sdometools.com/tools/bookingin_tool/attachments/#{URI.escape(filename)}"
  end

  def legacy_urls
    return [] if legacy_field.blank?

    attachment_list = []
    current_attachment = ''

    legacy_field.split(',').select do |attachment|
      current_attachment += attachment
      if attachment != '' and has_a_file_extension?(attachment)
        attachment_list.push(current_attachment)
        current_attachment = ''
      elsif current_attachment != ''
          current_attachment += ','
      end
    end

    attachment_list.map { |url| legacy_url(url) }
  end

  def legacy_url?(url)
    legacy_urls.include?(url)
  end

  def delete_legacy_url(url)
    attachment = GoodsReceivedNotice::Attachment.new(url)
    legacy_field.sub!(",#{attachment.filename}", '')
    goods_received_notice.save!
  end

  def current_urls
    raise NotImplementedError.new(:current_urls)
  end

  def current_url?(url)
    find_attachment_model_by_url(url).present?
  end

  def delete_current_url(url)
    find_attachment_model_by_url(url).try(:destroy)
    goods_received_notice.reload
  end

  def find_attachment_model_by_url(url)
    raise NotImplementedError.new(:current_urls)
  end

  def has_a_file_extension?(filename)
    /\.[a-z]{3,4}/.match(filename)
  end
end
