RSpec.describe Barcode, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:sku) }
    it { should validate_presence_of(:barcode) }
    it { should_not allow_value('\'123456').for(:barcode) }
    it { should_not allow_value('\"123456').for(:barcode) }
  end

  context 'validations' do
    it 'should only allow one barcode per sku id' do
      create(:barcode, sku_id: 1, barcode: '123456')
      expect { create(:barcode, sku_id: 1, barcode: '123456') }.to raise_exception ActiveRecord::RecordInvalid
    end
  end

  describe '#latest scope' do
    before do
      4.times { create(:barcode) }
    end

    context "orders by updated_at desc" do
      it "returns ordered data" do
        expect(Barcode.latest.pluck(:id)).to eq [4, 3, 2, 1]
      end
    end
  end
end
