class SupplierTerms < ActiveRecord::Base
  belongs_to :supplier

  validates :season, presence: true

  has_attached_file :confirmation
  validates_attachment_content_type :confirmation, content_type: %w(image/jpeg
                                                                    image/pjpeg
                                                                    image/png
                                                                    image/x-png
                                                                    application/pdf
                                                                    application/x-pdf)

  store :terms, accessors: %i(credit_limit
                              pre_order_discount
                              credit_terms_pre_order
                              re_order_discount
                              credit_terms_re_order
                              faulty_returns_discount
                              settlement_discount
                              marketing_contribution
                              rebate_structure
                              risk_order_details
                              mark_down_contribution_details
                              cancellation_allowance
                              stock_swap_allowance
                              bulk_order_details
                              samples
                              product_imagery
                              agreed_with
                              by
                              comments)

  def as_json(options = {})
    super.tap do |terms|
      terms.merge!(terms.delete('terms'))
    end
  end
end
