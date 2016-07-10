require 'json'

class SpreeProductInformation
  def initialize(information)
    @information = information
  end

  def build_json
    JSON.generate(information)
  end

  private

  attr_reader :information
end

