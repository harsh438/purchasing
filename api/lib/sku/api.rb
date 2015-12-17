class Sku::Api
  def config
    @config ||= Rails.application.config.pvx_credentials
  end

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def find(fields, custom_url = nil)
    @response = Excon.post(custom_url || config[:url],
                           body: fields.merge!(key: config[:key],
                                               token: config[:token]).to_json,
                           headers: headers)

    Sku::ApiResponse.new(@response)
  end
end
