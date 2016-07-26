import React from 'react';
import GoodsReceivedNoticesConditionFormInput from './_condition_form_input';

export default class GoodsReceivedNoticesConditionForm extends React.Component {
  render() {
    return (
      <div>
        <form onChange={this.props.onChange.bind(this)}>
          <section className="grn_condition" style={{ fontSize: '12px' }}>
            <section className="grn_condition__header">
              Delivery Condition
            </section>
            <section className="grn_condition__body">
              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="booked_in"
                label="Delivery Booked In?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="arrived_correctly"
                label="Delivery Arrived Correctly?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="packing_list_received"
                label="Packing List Received?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="items_in_quarantine"
                label="Any Items in Quarantine?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="cartons_good_condition"
                label="Cartons in Good Condition?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="grn_or_po_marked_on_cartons"
                label="GRN or PO Marked on Cartons?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.props.condition}
                conditionKey="cartons_palletised_correctly"
                label="Cartons Palletised Correctly (16 or more)?" />
            </section>
          </section>
        </form>
      </div>
    );
  }
}
