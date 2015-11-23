class Supplier < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  has_many :supplier_vendors, foreign_key: :SupplierID, class_name: 'SupplierVendor'
  has_many :vendors, through: :supplier_vendors
  has_one :details, class_name: 'SupplierDetail'
  accepts_nested_attributes_for :details

  after_initialize :ensure_details

  map_attributes id: :SupplierID,
                 name: :SupplierName,
                 returns_address_name: :cName,
                 returns_address_number: :cNumber,
                 returns_address_1: :cAddress1,
                 returns_address_2: :cAddress2,
                 returns_address_3: :cAddress3,
                 returns_postal_code: :cPostCode,
                 returns_process: :cReturnProcedures

  def self.relevant
    joins('inner join suppliers_to_brands sb on suppliers.SupplierID = sb.SupplierID')
      .where('sb.BrandID in (select distinct orderTool_venId from purchase_orders)')
      .uniq
  end

  def self.alphabetical
    order(name: :asc)
  end

  def as_json(options = {})
    super.merge(details.as_json)
  end

  private

  def ensure_details
    self.details || self.build_details
  end
end
