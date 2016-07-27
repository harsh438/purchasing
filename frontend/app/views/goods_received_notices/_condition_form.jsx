import React from 'react';
import { find } from 'lodash';
import GoodsReceivedNoticesConditionFormInput from './_condition_form_input';

export default class GoodsReceivedNoticesConditionForm extends React.Component {
  issueForType(issueType) {
    return find(this.props.issues, issue => issue.issue_type === issueType);
  }

  render() {
    return (
      <div>
        <form onSubmit={this.props.onSubmit.bind(this)}>
          <section className="grn_condition" style={{ fontSize: '12px' }}>
            <section className="grn_condition__header">
              Delivery Condition
            </section>
            <section className="grn_condition__body">
              <GoodsReceivedNoticesConditionFormInput
                issueType="booked_in"
                onChange={this.props.onChange.bind(this)}
                value={this.props.condition['booked_in']}
                label="Delivery Booked In?" />

              <GoodsReceivedNoticesConditionFormInput
                issueType="arrived_correctly"
                onChange={this.props.onChange.bind(this)}
                value={this.props.condition['arrived_correctly']}
                label="Delivery Arrived Correctly?" />

              <GoodsReceivedNoticesConditionFormInput
                issueType="packing_list_received"
                onChange={this.props.onChange.bind(this)}
                value={this.props.condition['packing_list_received']}
                label="Packing List Received?" />

              <GoodsReceivedNoticesConditionFormInput
                issueType="items_in_quarantine"
                onChange={this.props.onChange.bind(this)}
                value={this.props.condition['items_in_quarantine']}
                label="Any Items in Quarantine?" />

              <GoodsReceivedNoticesConditionFormInput
                issueType="cartons_good_condition"
                onChange={this.props.onChange.bind(this)}
                onSubformChange={this.props.onSubformChange.bind(this)}
                value={this.props.condition['cartons_good_condition']}
                issue={this.issueForType('cartons_good_condition')}
                label="Cartons in Good Condition?"
                hasSubform />

              <GoodsReceivedNoticesConditionFormInput
                issueType="grn_or_po_marked_on_cartons"
                onChange={this.props.onChange.bind(this)}
                value={this.props.condition['grn_or_po_marked_on_cartons']}
                label="GRN or PO Marked on Cartons?" />

              <GoodsReceivedNoticesConditionFormInput
                issueType="cartons_palletised_correctly"
                onChange={this.props.onChange.bind(this)}
                value={this.props.condition['cartons_palletised_correctly']}
                label="Cartons Palletised Correctly (16 or more)?" />
            </section>
            <div className="text-right" styles={{ marginTop: '10px' }}>
              <button className="btn btn-warning">Update Condition</button>
            </div>
          </section>
        </form>
      </div>
    );
  }
}
