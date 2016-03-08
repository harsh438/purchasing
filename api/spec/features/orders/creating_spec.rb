feature 'Creating order' do
  subject { JSON.parse(page.body) }

  scenario 'Re-ordering stock' do
    when_i_want_to_reorder_certain_products
    then_i_should_be_able_to_create_a_new_order
  end

  scenario 'Re-ordering stock with season' do
    when_i_want_to_reorder_certain_products_with_a_season
    then_i_should_be_able_to_create_a_new_order_with_a_season
  end

  def when_i_want_to_reorder_certain_products
    page.driver.post orders_path(order: { name: 'Nice order' })
  end

  def then_i_should_be_able_to_create_a_new_order
    expect(subject).to include('id' => a_kind_of(Integer))
    expect(subject).to include('name' => 'Nice order')
    expect(subject).to include('status' => 'new')
  end

  def when_i_want_to_reorder_certain_products_with_a_season
    page.driver.post orders_path(order: { name: order_name, season: season })
  end

  def then_i_should_be_able_to_create_a_new_order_with_a_season
    expect(subject).to include('id' => a_kind_of(Integer))
    expect(subject).to include('name' => order_name)
    expect(subject).to include('season' => season)
    expect(subject).to include('status' => 'new')
  end

  let(:order_name) { Faker::Lorem.characters(15) }
  let(:season) { Faker::Lorem.characters(15) }

end
