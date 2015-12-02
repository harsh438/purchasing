class Sku::Api
  def url
    'http://www.example.com/api'
  end

  def find(fields, custom_url = nil)
    connection = Excon.new(custom_url || url)
    connection.get(query: fields)
  end
end
