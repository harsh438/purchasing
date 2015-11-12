describe Order::Exporter do
  before(:each) { Order::Exporter.new.export(orders) }

  context 'when exporting single order' do
    context 'and the order has a single line item' do
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

    context 'and the order has multiple line items' do
      let(:orders) { create_list(:order, 1, line_items: line_items) }

      context 'and the line items are of the same brand and drop date' do
        let(:line_items) do
          create_list(:order_line_item, 2, vendor: create(:vendor),
                                           drop_date: 2.weeks.from_now)
        end

        context 'then the orders exports' do
          subject { orders.first.exports }
          its(:count) { is_expected.to eq(1) }
        end

        context 'then the generated purchase orders' do
          subject { orders.first.exports.map(&:purchase_order).uniq.compact }
          its(:count) { is_expected.to eq(1) }
        end
      end

      context 'and the line items are not of the same brand and drop date' do
        let(:line_items) do
          [create(:order_line_item, vendor: create(:vendor),
                                    drop_date: 1.week.from_now),
           create(:order_line_item, vendor: create(:vendor),
                                    drop_date: 2.weeks.from_now)]
        end

        context 'then the orders exports' do
          subject { orders.first.exports }
          its(:count) { is_expected.to eq(2) }
        end

        context 'then the generated purchase orders' do
          subject { orders.first.exports.map(&:purchase_order).compact }
          its(:count) { is_expected.to eq(2) }
        end
      end
    end
  end

  context 'when exporting multiple orders' do
  end
end
