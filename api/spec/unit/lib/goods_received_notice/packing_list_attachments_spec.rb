describe GoodsReceivedNotice::PackingListAttachments do
  let(:attachments) { described_class.new(grn) }

  context 'when listing both legacy and current URLs' do
    let(:grn) { create(:goods_received_notice, :with_both_packing_lists) }
    subject { attachments.urls }
    its(:count) { is_expected.to eq(5) }
  end

  context 'when listing URLs with commas in names' do
    let(:grn) { create(:goods_received_notice, :with_packing_list_with_invalid_characters) }
    subject { attachments.urls }
    its(:count) { is_expected.to eq(1) }
  end

  context 'when deleting legacy URL' do
    let(:grn) { create(:goods_received_notice, :with_multiple_packing_lists) }

    before(:each) do
      attachments.delete_by_url(attachments.urls.second)
    end

    context 'then the attachment urls' do
      subject { attachments.urls }
      its(:count) { is_expected.to eq(2) }
    end
  end

  context 'when deleting current URL' do
    let(:grn) { create(:goods_received_notice, :with_both_packing_lists) }

    before(:each) do
      attachments.delete_by_url(attachments.urls.last)
    end

    context 'then the attachment urls' do
      subject { attachments.urls }
      its(:count) { is_expected.to eq(4) }
    end
  end
end
