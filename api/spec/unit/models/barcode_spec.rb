RSpec.describe Barcode, type: :model do

  describe "#latest scope" do
    before do
      4.times { create(:barcode) }
    end
    context "orders by updated_at desc" do
      it "returns ordered data" do
        expect(Barcode.latest.pluck(:id)).to eq Barcode.order('barcodes.updated_at DESC').pluck(:id)
      end
    end
  end

end
