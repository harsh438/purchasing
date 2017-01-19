class PVX::Wrapper
  include HTTParty

  def initialize
    @credentials ||= Rails.application.config.pvx_credentials.with_indifferent_access
  end

  def sku_by_barcode_and_surfdome_size(barcode, size, retries=1)
    make_request(url('/sku_lookup_by_barcode_and_surfdome_size'), { barcode: barcode, size: size }, retries)
  end

  def sku_by_barcode(barcode, retries=1)
    make_request(url('/sku_lookup_by_barcode'), { barcode: barcode }, retries)
  end

  def sku_by_man_sku_and_man_size(man_sku, man_size, retries=1)
    make_request(url('/sku_lookup_by_man_sku_and_man_size'), { man_sku: man_sku, size: man_size }, retries)
  end

  private

  def make_request(uri, params, retries)
    begin
      response = HTTParty.post(uri, body: body.merge(params).to_json)
    rescue Errno::ETIMEDOUT, Timeout::Error
      if retries > 0
        sleep 1
        make_request(uri, params, retries-1)
      else
        raise PVXTimeoutError, 'Connection timed out. Check the url is correct'
      end
    end
    response
  end

  def body
    {
      key: credentials[:key],
      token: credentials[:token]
    }
  end

  def url(path)
    credentials[:base_url] + path
  end

  attr_reader :credentials
end

class PVXTimeoutError < StandardError; end
