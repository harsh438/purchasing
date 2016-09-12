require 'jsonpath'

module JSONFixture
  def fixture(path)
    JsonPath.for(File.read(path))
  end

  def modify_fixture(path, subpath = '$..')
    elm = JsonPath.for(
      JsonPath.on(fixture(path).to_json, subpath).to_json
    )
    elm.tap do |json|
      yield(json) if block_given?
    end
  end
end
