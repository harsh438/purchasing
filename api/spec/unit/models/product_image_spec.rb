RSpec.describe ProductImage, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:product) }
  end

  describe "#as_json" do
    subject(:product_image) { create(:product_image) }

    it "Includes the correct legacy information" do
      expect(product_image.as_json).to include(
        url: "http://asset1.surfcdn.com/#{product_image.its_reference}?w=400",
        position: product_image.position,
        dimensions: {
          height: product_image.height,
          width: product_image.width
        },
        elasticera_reference: product_image.its_reference,
        legacy_id: product_image.id,
        s3_path: product_image.s3_path
      )
    end
  end
end
