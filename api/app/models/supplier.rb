class Supplier < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  def self.relevant
    joins('inner join suppliers_to_brands sb on suppliers.SupplierID = sb.SupplierID')
      .where('sb.BrandID in (select distinct orderTool_venId from purchase_orders)')
      .uniq
  end

  scope :alphabetical, -> { order(name: :asc) }
  scope :with_details, -> { includes(:details) }
  scope :with_contacts, -> { includes(:contacts) }
  scope :latest, -> { order(id: :desc) }

  has_many :supplier_vendors, foreign_key: :SupplierID, class_name: 'SupplierVendor'
  has_many :vendors, through: :supplier_vendors

  has_one :details, class_name: 'SupplierDetail'
  accepts_nested_attributes_for :details

  has_many :contacts, class_name: 'SupplierContact'
  accepts_nested_attributes_for :contacts

  has_many :buyers, class_name: 'SupplierBuyer'
  accepts_nested_attributes_for :buyers

  has_many :terms, class_name: 'SupplierTerms'

  after_initialize :ensure_primary_key

  map_attributes id: :SupplierID,
                 name: :SupplierName,
                 returns_address_name: :cName,
                 returns_address_number: :cNumber,
                 returns_address_1: :cAddress1,
                 returns_address_2: :cAddress2,
                 returns_address_3: :cAddress3,
                 returns_postal_code: :cPostCode,
                 returns_process: :cReturnProcedures

  paginates_per 50

  def as_json(options = {})
    super.tap do |supplier|
      supplier['created_at'] = supplier['created_at'].to_s
      supplier['updated_at'] = supplier['updated_at'].to_s
    end
  end

  def as_json_with_details_buyers_vendors_contacts_and_terms
    details.as_json.merge(as_json).tap do |supplier|
      supplier['buyers'] = buyers.map(&:as_json)
      supplier['vendors'] = vendors.map(&:as_json)
      supplier['contacts'] = contacts.map(&:as_json)
      supplier['terms'] = terms.last(10).reverse.map(&:as_json_with_url_and_vendor)
      supplier['terms_by_vendor'] = terms_by_vendor

      if default_terms
        supplier['default_terms'] = default_terms.as_json_with_url_and_vendor
      else
        supplier['default_terms'] = nil
      end
    end
  end

  def terms_by_vendor
    terms.reduce({}) do |terms_by_vendor, terms|
      terms_by_vendor[terms.vendor_id] ||= { default: {}, history: [] }
      terms_attrs = terms.as_json_with_url_and_vendor
      terms_by_vendor[terms.vendor_id][:history] << terms_attrs

      if terms.default?
        terms_by_vendor[terms.vendor_id][:default] = terms_attrs
      end

      terms_by_vendor
    end.values
  end

  def default_terms
    terms.find { |terms| terms.default }
  end

  def details
    super || build_details
  end

  def terms=(terms_attrs)
    return if terms_attrs.is_a?(Array)

    vendor_terms = terms.where(vendor_id: terms_attrs['vendor_id'])
    vendor_terms.update_all(default: false)

    if vendor_terms.length < 1 or new_confirmation_upload?(terms_attrs)
      create_new_terms(terms_attrs)
    else
      update_most_recent_terms(vendor_terms, terms_attrs)
    end
  end

  private

  def new_confirmation_upload?(terms_attrs)
    terms_attrs.has_key?('confirmation')
  end

  def create_new_terms(terms_attrs)
    new_terms = terms.build(terms_attrs.merge(default: true, parent_id: terms.last.try(:id)))
    new_terms.validate!
  end

  def update_most_recent_terms(vendor_terms, terms_attrs)
    latest_terms = vendor_terms.last
    latest_terms.update(terms_attrs.merge(default: true))
    latest_terms.validate!
  end

  def ensure_primary_key
    self.id ||= (self.class.maximum(:id) || 0) + 1
  end
end
