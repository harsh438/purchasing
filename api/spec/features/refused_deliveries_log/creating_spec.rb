feature 'Refused Deliveries Log create' do
  subject { JSON.parse(page.body) }

  scenario 'Creating a Refused Deliveries Log' do
    when_i_create_a_refused_delivery_log
    then_i_should_be_provided_with_refused_delivery_log_attributes
  end

  def when_i_create_a_refused_delivery_log
    page.driver.post refused_deliveries_logs_path(refused_deliveries_log: refused_deliveries_log_attrs)
  end

  def then_i_should_be_provided_with_refused_delivery_log_attributes
    expect(subject).to include(refused_deliveries_log_attrs)
  end

  private

  let(:refused_deliveries_log_attrs) do
    attributes_for(:refused_deliveries_log, :with_details).stringify_keys
  end
end
