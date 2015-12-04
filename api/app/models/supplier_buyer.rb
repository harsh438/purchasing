class SupplierBuyer < ActiveRecord::Base
  def self.buyers
    uniq.where.not(buyer_name: nil).pluck(:id, :buyer_name).map do |id, name|
      { id: id, name: name }
    end
  end

  def self.buyer_assistants
    uniq.where.not(assistant_name: nil).pluck(:id, :assistant_name).map do |id, name|
      { id: id, name: name }
    end
  end

  belongs_to :supplier
end
