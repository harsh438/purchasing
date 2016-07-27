import React from 'react';
import GoodsReceivedNoticesConditionFormInput from './_condition_form_input';
import GoodsReceivedNoticesConditionShortSubform from './_condition_short_subform';

export default class GoodsReceivedNoticesConditionForm extends React.Component {
  componentWillMount() {
    this.state = { condition: this.props.condition };
  }

  handleConditionChange(value, { target }) {
    const condition = this.state.condition;
    condition[target.name] = parseInt(value);
    this.setState({ condition });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onSubmit(e, this.state.condition);
  }

  render() {
    return (
      <div>
        <form onSubmit={this.handleSubmit.bind(this)}>
          <section className="grn_condition" style={{ fontSize: '12px' }}>
            <section className="grn_condition__header">
              Delivery Condition
            </section>
            <section className="grn_condition__body">
              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="booked_in"
                onChange={this.handleConditionChange.bind(this)}
                label="Delivery Booked In?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="arrived_correctly"
                onChange={this.handleConditionChange.bind(this)}
                label="Delivery Arrived Correctly?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="packing_list_received"
                onChange={this.handleConditionChange.bind(this)}
                label="Packing List Received?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="items_in_quarantine"
                onChange={this.handleConditionChange.bind(this)}
                label="Any Items in Quarantine?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="cartons_good_condition"
                onChange={this.handleConditionChange.bind(this)}
                label="Cartons in Good Condition?">
                <GoodsReceivedNoticesConditionShortSubform
                  unitsAffected=""
                  files={[]} />
              </GoodsReceivedNoticesConditionFormInput>

              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="grn_or_po_marked_on_cartons"
                onChange={this.handleConditionChange.bind(this)}
                label="GRN or PO Marked on Cartons?" />

              <GoodsReceivedNoticesConditionFormInput
                condition={this.state.condition}
                conditionKey="cartons_palletised_correctly"
                onChange={this.handleConditionChange.bind(this)}
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
