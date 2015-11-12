describe Order::Exporter do
  before(:each) { Order::Exporter.new.export(orders) }

  context 'when exporting single order with a single line item' do
    let(:orders) { create_list(:order, 1, line_item_count: 1) }

    context 'then the order' do
      subject { orders.first }
      it { is_expected.to be_exported }
    end

    context 'then the orders exports' do
      subject { orders.first.exports }
      its(:count) { is_expected.to eq(1) }
    end

    context 'then the generated purchase orders' do
      subject { orders.first.exports.map(&:purchase_order).compact }
      its(:count) { is_expected.to eq(1) }
    end
  end
end
