import React from 'react';
import { map } from 'lodash';

export default class SkusBarcodeTable extends React.Component {
  componentWillMount() {
    this.state = { editing: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ editing: false });
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
    return map(this.props.barcodes, this.renderRow, this);
  }

  renderRow(barcode) {
    return (
      <tr>
        <td>
          {this.renderBarcode(barcode)}
        </td>
      </tr>
    );
  }

  renderBarcode(barcode) {
    if (this.state.editing) {
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
          <button onClick={this.handleEditButton.bind(this)} className="btn btn-success pull-right">
            <i className="glyphicon glyphicon-edit"></i>&nbsp;Edit
          </button>
        </div>
      </div>
    );
  }

  renderWithEdit(barcode) {
    return (
      <form className="form">
        <div className="form-group col-md-10">
          <input className="form-control" type="text" value={barcode.barcode} />
        </div>
        <div className="form-group col-md-2">
          <input type="submit" value="Save" className="btn btn-success" />
        </div>
      </form>
    );
  }

  handleEditButton() {
    this.setState({ editing: true });
  }
}
