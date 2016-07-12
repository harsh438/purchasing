require './lib/spree_product_information.rb'

describe SpreeProductInformation do
  subject(:product_info) { described_class.new(params) }
  let(:params)           { create(:product_info_params) }
  describe "#as_json" do
    xit "Includes parent information" do
      expect(product_info.as_json).to include params[:parent]
    end

    context "No children" do
      it "options is empty" do
        expect(product_info.as_json).to include options: []
      end
    end

    context "When there are children" do
      it "options => Size" do
        expect(product_info.as_json).to include options: "Size"
      end
    end
  end
end
