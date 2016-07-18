RSpec.describe Part do
  subject(:part) { described_class.new(kit_manager) }
  let(:kit_manager) { create(:kit_manager) }

  describe "#as_json" do
    it "Includes an itemcode" do
      expect(part.as_json).to eq kit_manager.itemCode
    end
  end
end
