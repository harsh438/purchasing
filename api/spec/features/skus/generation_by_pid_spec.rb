feature 'SKU generation by PID' do
  subject { JSON.parse(page.body) }

  scenario 'Generating skus with an non_existent PID should fail' do
    when_i_generate_from_an_non_existent_pid
    then_the_api_should_return_404
  end

  def when_i_generate_from_an_non_existent_pid
    page.driver.post create_by_pid_skus_path, { product_id: non_existent_pid }
  end

  def then_the_api_should_return_404
    expect(page.driver.status_code).to be(404)
  end

  let(:product) { create(:product) }
  let(:non_existent_pid) { 999999999 }
end
