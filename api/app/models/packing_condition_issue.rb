class PackingConditionIssue < ActiveRecord::Base
  self.table_name = :paking_conditions_issues

  include LegacyMappings

  map_attributes id: :id,
                 packing_condition_id: :packing_conditions_id,
                 issue_type: :issue_type,
                 sku_list: :sku_list,
                 pid_list: :pid_list,
                 issue_id: :issue_id,
                 comments: :comments,
                 units_affected: :units_affected,
                 time_taken_to_resolve: :time_taken_to_resolve
end
