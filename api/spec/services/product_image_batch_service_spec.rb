require 'spec_helper'

RSpec.describe ProductImageBatchService do
  include JSONFixture

  shared_examples 'replacing assets' do
    it 'marks existing assets as deleted' do
      expect { subject }
        .to change { images.map { |i| i.reload.deleted_at.present? } }
        .from([false, false])
        .to([true, true])
    end

    it 'marks existing assets as no longer accepted' do
      expect { subject }
        .to change { images.map { |i| i.reload.accepted_at.present? } }
        .from([true, true])
        .to([false, false])
    end

    it 'creates new assets' do
      subject
      sources = ProductImage.where(import_batch_id: batch_id)
                            .order(:position)
                            .pluck(:source_path)
      expected = JsonPath.on(assets.to_a, '$..s3.url')
      expect(sources).to match(expected)
    end

    it 'created assets are assigned to correct product' do
      subject
      pids = get_from_batch(batch_id, :product_id)
      expect(pids).to all(be(product_id))
    end

    it 'marks the product as updated' do
      expect { subject }.to change { product.reload.updated_at }
    end
  end

  let(:product) { create(:product, updated_at: 2.days.ago) }
  let(:product_id) { product.id }
  let(:negative_pid) { -234 }
  let(:batch_id) { 98765 }

  let(:assets) do
    modify_fixture(
      'spec/fixtures/files/sample_asset.json',
      '$..assets',
    ) do |json|
      json.gsub!('$..pid') { provided_id }
      json.gsub!('$..pids') { [provided_id] }
    end.obj.flatten
  end

  let!(:images) do
    2.times.map do |i|
      ProductImage.create!(
        product_id: product_id,
        accepted_at: Time.current,
        negative_ref: negative_pid,
        position: i + 1,
      )
    end
  end

  describe '#replace_assets' do
    subject { described_class.new.replace_assets(provided_id, batch_id, assets) }

    context 'with a positive product id' do
      let(:provided_id) { product_id }
      include_examples 'replacing assets'
    end

    context 'with a negative pid' do
      let(:provided_id) { negative_pid }

      include_examples 'replacing assets'

      it 'newly created assets have a negative_ref' do
        subject
        negative_refs = get_from_batch(batch_id, :negative_ref)
        expect(negative_refs).to all(be(negative_pid))
      end
    end

    context 'with a string id' do
      let(:provided_id) { product_id.to_s }
      include_examples 'replacing assets'
    end
  end

  describe '#append_assets' do
    subject { described_class.new.append_assets(provided_id, batch_id, assets) }

    let(:provided_id) { product_id }

    it 'new assets are appended to existing assets' do
      appended = subject
      ids = ProductImage.where(product_id: provided_id)
                        .order(:position)
                        .pluck(:id)
      expect(ids).to eq(images.map(&:id) + appended.map(&:id))
    end

    it 'marks the product as updated' do
      expect { subject }.to change { product.reload.updated_at }
    end
  end

  describe '#prepend_assets' do
    subject { described_class.new.prepend_assets(provided_id, batch_id, assets) }

    let(:provided_id) { product_id }

    it 'new assets are prepended to existing assets' do
      appended = subject
      ids = ProductImage.where(product_id: provided_id)
                        .order(:position)
                        .pluck(:id)
      expect(ids).to eq(appended.map(&:id) + images.map(&:id))
    end

    it 'marks the product as updated' do
      expect { subject }.to change { product.reload.updated_at }
    end
  end

  def get_from_batch(batch_id, attribute)
    ProductImage.where(import_batch_id: batch_id)
                .order(:position)
                .pluck(attribute)
  end
end
