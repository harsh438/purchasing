feature 'Build PDF', booking_db: true do
  subject { page.body }

  scenario 'build grn paper' do
    when_i_request_grn_paper
    then_i_should_render_pdf_grn_paper
  end

  scenario 'build grn check sheet' do
    when_i_request_grn_check_sheet
    then_i_should_render_pdf_check_sheet
  end

  def when_i_request_grn_paper
    create_grn
    visit packing_list_path(format: :pdf, type: 'grn', id: 2)
  end

  def then_i_should_render_pdf_grn_paper
    text_analysis = PDF::Inspector::Text.analyze(subject)
    expect(text_analysis.strings.last).to eq('NO OF PALLETS: 1.0')
    expect(text_analysis.strings.first).to eq('GRN: ')
    page_analysis = PDF::Inspector::Page.analyze(subject)
    expect(page_analysis.pages.size).to eq(1)
  end

  def when_i_request_grn_check_sheet
    create_grn
    visit packing_list_path(format: :pdf, type: 'check_sheet', id: 2)
  end

  def then_i_should_render_pdf_check_sheet
    text_analysis = PDF::Inspector::Text.analyze(subject)
    expect(text_analysis.strings.last).to eq('Comments:')
    expect(text_analysis.strings.second).to eq('GOODS IN CHECK SHEET')
    page_analysis = PDF::Inspector::Page.analyze(subject)
    expect(page_analysis.pages.size).to eq(1)
  end

  private
  def create_grn
    create_list(:goods_received_notice, 2, :with_packing_list,
                                           :with_purchase_orders,
                                           delivery_date: 2.days.ago)
  end
end
