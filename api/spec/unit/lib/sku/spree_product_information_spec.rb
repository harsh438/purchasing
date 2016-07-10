require './lib/spree_product_information.rb'

describe SpreeProductInformation do
  subject(:product_info) { described_class.new(information) }
  let(:information) { double :information }

  it "Builds given properties into JSON" do
    expect(product_info.build_json).to eq ""
  end
end
