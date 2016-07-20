feature 'Refused deliveries Upload' do
  subject { JSON.parse(page.body) }

  scenario 'Adding a packing list file to a GRN' do
    when_i_upload_a_refused_delivery_log_image
    then_the_image_should_be_stored
  end

  def when_i_upload_a_refused_delivery_log_image
    page.driver.post(refused_deliveries_log_path(refused_deliveries_log),
                     _method: 'patch',
                     refused_deliveries_log: { refused_deliveries_log_images_attributes: [{ image: log_image_upload }] })
  end

  def then_the_image_should_be_stored
    expect(subject['images'].count).to eq(1)
  end

  private

  let(:refused_deliveries_log) { create(:refused_deliveries_log) }

  let(:log_image_upload) do
    fixture_file_upload(Rails.root.join('spec/fixtures/files/1x1.jpg'), 'image/jpeg')
  end
end
