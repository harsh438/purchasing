feature 'Combine GRNs' do
  subject { JSON.parse(page.body) }

  scenario 'Moving GRN to day with another GRN from same Supplier' do
    given_grns_from_same_supplier_on_same_day_need_to_be_combined
    when_an_intake_planner_combines_grns
    then_all_grn_events_should_be_moved_to_grn
  end

  def given_grns_from_same_supplier_on_same_day_need_to_be_combined
    create_grns_from_same_supplier_on_same_day
  end

  def when_an_intake_planner_combines_grns
    path = combine_goods_received_notice_path(to_grn)
    page.driver.post(path, _method: 'post', from: from_grn.id)
  end

  def then_all_grn_events_should_be_moved_to_grn
    expect(subject['id']).to eq(to_grn.id)
    expect(subject['goods_received_notice_events'].count).to eq(2)
    expect(subject['packing_list_urls'].count).to eq(10)
    expect(GoodsReceivedNotice.count).to eq(1)
  end

  private

  let(:grns_from_same_supplier_on_same_day) do
    create_list(:goods_received_notice, 2, :with_purchase_orders,
                                           :with_both_packing_lists)
  end
  alias_method :create_grns_from_same_supplier_on_same_day, :grns_from_same_supplier_on_same_day

  let(:from_grn) do
    grns_from_same_supplier_on_same_day.first
  end

  let(:to_grn) do
    grns_from_same_supplier_on_same_day.second
  end
end
