class SupplierTerms < ActiveRecord::Base
  include Searchable

  scope :latest, -> { order(id: :desc) }

  belongs_to :supplier

  validates :season, presence: true

  has_attached_file :confirmation
  validates_attachment_content_type :confirmation, content_type: %w(image/jpeg
                                                                    image/pjpeg
                                                                    image/png
                                                                    image/x-png
                                                                    application/pdf
                                                                    application/x-pdf)

  paginates_per 50

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
                              sale_or_return_details
                              samples
                              product_imagery
                              agreed_with
                              by
                              comments)

  def supplier_name
    supplier.name
  end

  def confirmed?
    confirmation.present?
  end

  def as_json(options = {})
    super.tap do |terms|
      terms['created_at'] = terms['created_at'].to_s
      terms.merge!(terms.delete('terms'))
    end
  end

  def as_json_with_url(term = {})
    as_json.tap do |term|
      term['by'] = by
      if confirmation.exists?
        term['confirmation_url'] = confirmation.expiring_url(300)
      end
    end
  end

  def as_json_with_url_and_supplier_name(term = {})
    as_json.tap do |term|
      term['supplier_name'] = supplier.try(:name)
      term['by'] = by
      if confirmation.exists?
        term['confirmation_url'] = confirmation.expiring_url(300)
      end
    end
  end
end
