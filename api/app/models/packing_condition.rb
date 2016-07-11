class PackingCondition < ActiveRecord::Base
  self.table_name = :packing_conditions_new

  include LegacyMappings

  map_attributes id: :ID,
                 grn_id: :grn,
                 arrived_correctly: :arrived_corectly,
                 cartons_good_condition: :cartons_good_condition,
                 packing_list_received: :packing_list_received,
                 grn_or_po_marked_on_cartons: :grn_or_po_marked_on_cartons,
                 packing_list_outside_of_carton: :packing_list_outside_of_carton,
                 cartons_sequentially_numbered: :cartons_sequentially_numbered,
                 packed_correctly: :packed_corectly,
                 packed_correctly_issues_id: :packed_corectly_issues_id,
                 cartons_markings_correct: :cartons_markings_correct,
                 cartons_palletised_correctly: :cartons_palletised_corectly,
                 packing_comments: :packing_comments,
                 barcoded: :barcoded,
                 poly_bagged: :poly_bagged,
                 general_comments: :general_comments,
                 attachments: :Attachments,
                 items_in_quarantine: :items_in_quarantine

  after_initialize :ensure_defaults

  private

  def ensure_defaults
    self.arrived_correctly ||= true
    self.booked_in ||= true
    self.cartons_good_condition ||= true
    self.packing_list_received ||= true
    self.grn_or_po_marked_on_cartons ||= true
    self.packing_list_outside_of_carton ||= true
    self.cartons_sequentially_numbered ||= false
    self.packed_correctly ||= true
    self.packed_correctly_issues_id ||= nil
    self.cartons_markings_correct ||= true
    self.cartons_palletised_correctly ||= true
    self.packing_comments ||= ''
    self.barcoded ||= true
    self.poly_bagged ||= true
    self.general_comments ||= ''
    self.attachments ||= ''
    self.items_in_quarantine ||= false
  end
end
