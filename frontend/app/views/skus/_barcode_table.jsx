import React from 'react';
import { map, assign } from 'lodash';

export default class SkusBarcodeTable extends React.Component {
  componentWillMount() {
    this.state = { editing: false };
    this.setBarcodes(this.props);
  }

  componentWillReceiveProps(nextProps) {
    this.setBarcodes(nextProps);
  }

  setBarcodes(props) {
    let barcodes = props.barcodes || [];
    barcodes.forEach((barcode) => { barcode.editing = false; });
    this.setState({ editing: false, barcodes });
  }

  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Barcodes</h3>
        </div>
        <div className="panel-body">
          <table className="table">
            <tbody>
              {this.renderRows()}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  renderRows() {
    return map(this.state.barcodes, this.renderRow, this);
  }

  renderRow(barcode) {
    return (
      <tr key={barcode.id}>
        <td>
          {this.renderBarcode(barcode)}
        </td>
      </tr>
    );
  }

  renderBarcode(barcode) {
    if (barcode.editing) {
      return this.renderWithEdit(barcode);
    } else {
      return this.renderWithoutEdit(barcode);
    }
  }

  renderWithoutEdit(barcode) {
    return (
      <div>
        <div className="col-md-10">{barcode.barcode}</div>
        <div className="col-md-2">
          <button onClick={this.handleEditButton.bind(this, barcode)} className="btn btn-success pull-right">
            <i className="glyphicon glyphicon-edit"></i>&nbsp;Edit
          </button>
        </div>
      </div>
    );
  }

  renderWithEdit(barcode) {
    return (
      <form className="form"
            onChange={this.handleFormChange.bind(this, barcode)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <div className="form-group col-md-10">
          <input className="form-control" type="text" defaultValue={barcode.barcode} name="barcode" />
        </div>
        <div className="form-group col-md-2">
          <input type="submit" value="Save" className="btn btn-success" />
        </div>
      </form>
    );
  }

  handleEditButton(barcode) {
    barcode.editing = true;
    this.setState({ barcodes: this.state.barcodes });
  }

  handleFormChange(edited_barcode, { target }) {
    edited_barcode[target.name] = target.value;
    this.setState({ barcodes: this.state.barcodes });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
  }
}
