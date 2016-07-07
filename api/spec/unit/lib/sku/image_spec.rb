require './lib/sku/image.rb'

RSpec.describe Image do
  subject(:image) { described_class.new(product_image) }
  let(:product_image)   { create(:product_image) }

  describe "#as_json" do
    it "Includes a url" do
      expect(image.as_json).to include url: "http://asset1.surfcdn.com/#{product_image.its_reference}?w=400"
    end

    it "Includes a position" do
      expect(image.as_json).to include position: product_image.position
    end

    it "Includes a dimensions hash, which includes a height and width " do
      expect(image.as_json).to include dimensions: { height: product_image.height, width: product_image.width }
    end

    it "Includes an elasticera_reference" do
      expect(image.as_json).to include elasticera_reference: product_image.its_reference
    end

    it "Includes a legacy_id" do
      expect(image.as_json).to include legacy_id: product_image.id
    end
  end
end
