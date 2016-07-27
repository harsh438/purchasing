feature 'GRN Issues', booking_db: true do
  scenario 'Updating a GRN with a new issue' do
    when_updating_a_grn_with_an_issue
    then_the_issue_should_be_created_correctly
  end

  def when_updating_a_grn_with_an_issue
    create_grn
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_attrs }
  end

  def then_the_issue_should_be_created_correctly
    expect(grn.goods_received_notice_issues.first.issue_type_id).to eq(3)
    expect(grn.goods_received_notice_issues.first.attachments).to eq(',1x1.jpg')
  end

  let(:grn) { create(:goods_received_notice, :with_purchase_orders) }
  alias_method :create_grn, :grn

  let(:grn_attrs) do
    { goods_received_notice_issues_attributes: [{
      issue_type: 'cartons_good_condition',
      goods_received_notice_issue_images_attributes: [{ image: grn_issue_image_fixture }]
    }] }
  end

  let(:grn_issue_image_fixture) do
    fixture_file_upload(File.new(Rails.root.join('spec', 'fixtures', 'files', '1x1.jpg')))
  end
end
