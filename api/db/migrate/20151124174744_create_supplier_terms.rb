class CreateSupplierTerms < ActiveRecord::Migration
  def change
    create_table :supplier_terms do |t|
      t.references :supplier, index: true
      t.string :season
      t.text :terms
      t.attachment :confirmation
      t.timestamps
    end
  end
end
