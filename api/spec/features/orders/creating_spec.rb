feature 'Creating order' do
  subject { JSON.parse(page.body) }

  scenario 'Re-ordering stock' do
    when_i_want_to_reorder_certain_products
    then_i_should_be_able_to_create_a_new_order
  end

  def when_i_want_to_reorder_certain_products
    page.driver.post orders_path(order: { name: 'Nice order' })
  end

  def then_i_should_be_able_to_create_a_new_order
    expect(subject).to include('id' => a_kind_of(Integer))
    expect(subject).to include('name' => 'Nice order')
    expect(subject).to include('status' => 'new')
  end
end
