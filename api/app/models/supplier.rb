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
      supplier['terms'] = terms.last(10).reverse.map(&:as_json_with_url)

      if default_terms
        supplier['default_terms'] = default_terms.as_json_with_url
      else
        supplier['default_terms'] = nil
      end
    end
  end

  def default_terms
    terms.find { |terms| terms.default }
  end

  def details
    super || build_details
  end

  def terms=(terms_attrs)
    return if terms_attrs.is_a?(Array)
    terms.update_all(default: false)
    terms.build(terms_attrs.merge(default: true, parent_id: terms.last.try(:id)))
  end

  private

  def ensure_primary_key
    self.id ||= (self.class.maximum(:id) || 0) + 1
  end
end
