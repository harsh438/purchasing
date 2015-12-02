require 'pp'

class SupplierTerms < ActiveRecord::Base
  belongs_to :supplier
  before_save :on_save

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

  def on_save
    if self.supplier_id and !(self.parent_id) and !(self.id)
      self.parent_id = self.supplier.terms.maximum(:id)
    end
  end

  def as_json(options = {})
    super.tap do |terms|
      terms.merge!(terms.delete('terms'))
    end
  end

  def as_json_with_url(term = {})
    as_json.tap do |term|
      if confirmation.exists?
        term['confirmation_url'] = confirmation.url
      end
    end
  end
end
