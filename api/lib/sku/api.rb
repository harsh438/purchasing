class Sku::Api
  def config
    @config ||= YAML.load_file(Rails.root.join('config/pvx.yml'))[Rails.env]
  end

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def find(fields, custom_url = nil)
    Excon.post(custom_url || config['url'],
                          body: fields.merge!(key: config['key'],
                                              token: config['token']).to_json,
                          headers: headers)
  end
end
