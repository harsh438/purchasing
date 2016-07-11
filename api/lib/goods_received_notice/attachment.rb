class GoodsReceivedNotice::Attachment < Struct.new(:url)
  def filename
    slash_index = url.rindex('/')
    return nil unless slash_index
    encoded_filename = url[slash_index + 1..-1]
    return nil unless encoded_filename
    parameter_index = encoded_filename.index('?')
    if parameter_index
      encoded_filename = encoded_filename[0..parameter_index - 1]
    end
    URI.decode(encoded_filename)
  end
end
