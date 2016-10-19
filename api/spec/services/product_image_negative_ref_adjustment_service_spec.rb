require 'spec_helper'

RSpec.describe ProductImageNegativeRefAdjustmentService do
  let!(:product_a) { create(:product) }
  let!(:product_b) { create(:product) }
  let!(:product_c) { create(:product) }
  let!(:purchase_order_a) {
    create(
      :purchase_order_line_item,
      pID: product_a.id,
      orderToolItemID: 12345,
      operator: 'OT_1234',
      status: 2
    )
  }
  let!(:purchase_order_b) {
    create(
      :purchase_order_line_item,
      pID: product_b.id,
      orderToolItemID: 98765,
      operator: 'OT_2345',
      status: 2
    )
  }
  let!(:purchase_order_c) {
    create(
      :purchase_order_line_item,
      pID: product_c.id,
      orderToolItemID: 54321,
      operator: 'OT_3456',
      status: 2
    )
  }
  let!(:image_a) {
    create(:product_image, negative_ref: -12345, product: product_a)
  }
  let!(:image_b) {
    create(:product_image, negative_ref: -98765, product: product_a)
  }
  # same negative ref but pointing to a different product
  let!(:image_c) {
    create(:product_image, negative_ref: -98765, product: product_b)
  }
  let!(:image_d) {
    create(:product_image, negative_ref: -54321, product: product_c)
  }

  # primarily testing the enumerable functionality
  describe '#to_a' do
    it 'yields a product image' do
      product_images = subject.to_a
      expect(product_images).to match [image_b, image_c]
    end
  end

  describe '#adjust' do
    let(:output) { StringIO.new }
    let(:logger) { Logger.new(output) }

    it 'will correct the negative_ref' do
      expect { subject.adjust(logger) }
        .to change { image_b.reload.negative_ref }
        .to(-12345)
    end

    it 'outputs the progress' do
      subject.adjust(logger)
      expect(output.string).to include(
        "Adjusted ##{image_b.id} (50%)",
        "Adjusted ##{image_c.id} (100%)",
      )
    end

    it 'touches the product' do
      future = Time.current + 5.days
      Timecop.freeze(future) do
        expect { subject.adjust(logger) }
          .to change { product_a.reload.updated_at.strftime('%F %T') }
          .to(future.strftime('%F %T'))
      end
    end

    context 'when unable to locate a negative_ref' do
      let!(:purchase_order_d) {
        create(
          :purchase_order_line_item,
          pID: product_b.id,
          orderToolItemID: 0,
          operator: 'OT_3456',
          status: 2
        )
      }

      before do
        purchase_order_b.delete
      end

      it 'logs the issue' do
        subject.adjust(logger)
        expect(output.string).to include(
          "Adjusted ##{image_b.id}",
          "ERROR ##{image_c.id}",
        )
      end
    end
  end
end
