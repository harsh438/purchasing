feature 'Sku CSV Export' do
  scenario 'Exporting CSV for specific PO' do
    when_exporting_skus_for_a_po
    then_i_should_receive_all_skus_in_that_po
  end

  def when_exporting_skus_for_a_po
    skus
    visit skus_path(format: :csv, purchase_order_id: po.id)
  end

  def then_i_should_receive_all_skus_in_that_po
    expect(csv_result_rows.count).to eq(skus.count)
  end

  let(:po) { create(:purchase_order) }

  let(:skus) do
    create_list(:sku, 5, :with_purchase_order_line_item, purchase_order: po)
  end

  let(:csv) { CSV.parse(page.body) }
  let(:csv_header_row) { csv.first }
  let(:csv_result_rows) { csv.drop(1) }
end
