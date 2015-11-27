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
    details.as_json.merge(super).tap do |supplier|
      if supplier['terms'].present?
        supplier['terms'].map! do |terms|
          terms.merge(terms.delete('terms'))
        end

        supplier['default_terms'] = supplier['terms'].last
      end
    end
  end

  def details
    super || build_details
  end

  def terms=(terms_attrs)
    terms.build(terms_attrs)
  end

  private

  def ensure_primary_key
    self.id ||= (self.class.maximum(:id) || 0) + 1
  end
end
