RSpec.describe SupplierTerms, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:supplier) }
    it { should belong_to(:vendor) }

    it { should validate_presence_of(:season) }
    it { should validate_numericality_of(:credit_limit) }

    it { should have_attached_file(:confirmation) }
    it do
      should validate_attachment_content_type(:confirmation)
      .allowing(
        'image/jpeg',
        'image/pjpeg',
        'image/png',
        'image/png',
        'application/pdf',
        'application/x-pdf',
        'message/rfc822'
        )
    end
  end
end
