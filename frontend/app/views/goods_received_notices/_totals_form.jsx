import React from 'react';

export default class GoodsReceivedNoticesTotalsForm extends React.Component {
  handleChangePalletsSubmit(e) {
    e.preventDefault();
    const { grnId, totalPallets } = this.props;
    this.props.onSave({ id: grnId, pallets: totalPallets });
  }

  render() {
    return (
      <form onChange={this.props.onChange.bind(this)}
            onSubmit={this.handleChangePalletsSubmit.bind(this)}>
        <div className="form-group">
          <label htmlFor="pallets">Total pallets:</label>
          <input className="form-control"
                 type="number"
                 id="pallets"
                 name="totalPallets"
                 step="0.0001"
                 value={this.props.totalPallets}
                 required />
        </div>

        <div className="text-right">
          <button className="btn btn-warning">Update pallets</button>
        </div>
      </form>
    );
  }
}
