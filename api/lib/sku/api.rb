class Sku::Api
  def url
    'http://www.example.com/'
  end

  def find(fields)
    connection = Excon.new(url)
    connection.get(query: fields)
  end
end
