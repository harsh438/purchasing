class SupplierTerms < ActiveRecord::Base
  include Searchable

  scope :latest, -> { order(id: :desc) }

  belongs_to :supplier
  belongs_to :vendor, class_name: 'Vendor'

  validates :season, presence: true
  validates :credit_limit, numericality: { allow_blank: true }
  validates :pre_order_discount, percentage_or_blank: true
  validates :credit_terms_pre_order, number_or_blank: true
  validates :credit_terms_re_order, number_or_blank: true
  validates :re_order_discount, percentage_or_blank: true
  validates :faulty_returns_discount, percentage_or_blank: true
  validates :settlement_discount, percentage_days_or_blank: true
  validates :pre_order_cancellation_allowance, percentage_or_blank: true
  validates :pre_order_stock_swap_allowance, percentage_or_blank: true
  validates :risk_order_agreement, percentage_date: true
  validates :bulk_order_agreement, nested_date: true
  validates :sale_or_return_agreement, nested_date: true
  validates :marketing_contribution, percentage_of: { of: %w(pre_order_total
                                                             season_total
                                                             year_total) }
  validates :markdown_contribution_details, percentage_of: { of: %w(pre_orders
                                                                    all_orders) }

  has_attached_file :confirmation
  validates_attachment_content_type :confirmation, content_type: %w(image/jpeg
                                                                    image/pjpeg
                                                                    image/png
                                                                    image/x-png
                                                                    application/pdf
                                                                    application/x-pdf
                                                                    message/rfc822)

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
                              risk_order_agreement
                              markdown_contribution_details
                              markdown_contribution_explanation
                              pre_order_cancellation_allowance
                              pre_order_stock_swap_allowance
                              bulk_order_agreement
                              sale_or_return_agreement
                              samples
                              product_imagery
                              agreed_with
                              by
                              comments
                              )

  def supplier_name
    supplier.name
  end

  def brand_name
    vendor.try(:name) || supplier_name
  end

  def confirmed?
    confirmation.present?
  end

  def as_json(options = {})
    super.tap do |terms|
      terms['created_at'] = terms['created_at'].to_s
      terms.merge!(terms.delete('terms'))

      %w(risk_order_agreement
         bulk_order_agreement
         sale_or_return_agreement).each do |field|
        if terms[field].present? and terms[field]['date'].present?
          terms[field]['date'] = Date.parse(terms[field]['date']).to_s
        end
      end
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

  def as_json_with_url_and_vendor(term = {})
    as_json.tap do |term|
      term['by'] = by
      term['vendor'] = vendor.as_json
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
