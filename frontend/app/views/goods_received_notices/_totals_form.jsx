import React from 'react';
import GoodsReceivedNoticesTotalsFormInput from './_totals_form_input';

export default class GoodsReceivedNoticesTotalsForm extends React.Component {
  handleSubmit(e) {
    e.preventDefault();
    const { grnId, noticeEvents, totalPallets, totalUnits } = this.props;
    this.props.onSave({ id: grnId,
                        noticeEvents: noticeEvents,
                        pallets: totalPallets,
                        unitsReceived: totalUnits });
  }

  renderCartonsReceivedInputs() {
    return (
      <div>
        <h4>Cartons Received</h4>
        <hr />

        {this.props.noticeEvents.map((event, index) =>
          <GoodsReceivedNoticesTotalsFormInput
            title={`#${event.purchaseOrderId}`}
            value={event.cartonsReceived}
            onChange={this.props.onEventCartonsReceivedChange.bind(this, event, index)}
            key={`event${event.id}`}
            step={1}
            htmlId={`event${event.id}`}
            htmlName={`event${event.id}`} />
        )}
      </div>
    );
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        <GoodsReceivedNoticesTotalsFormInput
          title="Total Received Units"
          value={this.props.totalUnits}
          onChange={this.props.onChange.bind(this)}
          key="units"
          htmlId="units"
          htmlName="totalUnits"
          required />

        <GoodsReceivedNoticesTotalsFormInput
          title="Total Expected Pallets"
          value={this.props.totalPallets}
          onChange={this.props.onChange.bind(this)}
          key="pallets"
          htmlId="pallets"
          htmlName="totalPallets"
          required />

        {this.props.warehouseLayout && this.renderCartonsReceivedInputs()}

        <div className="text-right">
          <button className="btn btn-warning">Update totals</button>
        </div>
      </form>
    );
  }
}
