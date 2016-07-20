import React from 'react';
import GoodsReceivedNoticesTotalsFormInput from './_totals_form_input';

export default class GoodsReceivedNoticesTotalsForm extends React.Component {
  handleSubmit(e) {
    e.preventDefault();
    const { grnId, totalPallets, totalUnits } = this.props;
    this.props.onSave({ id: grnId, pallets: totalPallets, unitsReceived: totalUnits });
  }

  render() {
    return (
      <form onChange={this.props.onChange.bind(this)}
            onSubmit={this.handleSubmit.bind(this)}>
        <GoodsReceivedNoticesTotalsFormInput
          title="Total Received Units"
          value={this.props.totalUnits}
          key="units"
          htmlId="units"
          htmlName="totalUnits" />

        <GoodsReceivedNoticesTotalsFormInput
          title="Total Expected Pallets"
          value={this.props.totalPallets}
          key="pallets"
          htmlId="pallets"
          htmlName="totalPallets" />


        <div className="text-right">
          <button className="btn btn-warning">Update totals</button>
        </div>
      </form>
    );
  }
}
