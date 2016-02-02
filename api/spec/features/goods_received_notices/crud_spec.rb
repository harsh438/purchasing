feature 'GRN CRUD' do
  subject { JSON.parse(page.body) }


  scenario 'Create a GRN' do
    when_i_have_purchase_orders_to_book_into_warehouse
    then_i_should_be_able_to_create_new_grn
  end

  def when_i_have_purchase_orders_to_book_into_warehouse
    page.driver.post goods_received_notices_path(goods_received_notice: grn_attrs)
  end

  def then_i_should_be_able_to_create_new_grn
    expect(subject).to include(grn_attrs)
  end

  private

  let(:grn_attrs) do
    { 'delivery_date' => Date.today.to_s }
  end
end
