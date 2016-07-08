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

  def self.find_or_create_with_grn(grn_id)
    condition = PackingCondition.find_by(grn_id: grn_id)
    return condition if condition

    PackingCondition.create(grn_id: grn_id,
                            arrived_correctly: true,
                            booked_in: true,
                            cartons_good_condition: true,
                            packing_list_received: true,
                            grn_or_po_marked_on_cartons: true,
                            packing_list_outside_of_carton: true,
                            cartons_sequentially_numbered: false,
                            packed_correctly: true,
                            packed_correctly_issues_id: nil,
                            cartons_markings_correct: true,
                            cartons_palletised_correctly: true,
                            packing_comments: '',
                            barcoded: true,
                            poly_bagged: true,
                            general_comments: '',
                            attachments: '',
                            items_in_quarantine: false)
  end
end
