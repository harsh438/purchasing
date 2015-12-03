class Sku::ApiResponse
  def initialize(response)
    @response = response
  end

  def status
    @response.headers['Status'].split(' ').first.to_i
  end

  def fields
    return {} if status != 200
    map_to_response(JSON.parse(@response.data[:body]))
  end

  private

  def map_to_response(fields)
    { sku: fields['sku'],
      barcode: fields['barcode'] }
  end
end
