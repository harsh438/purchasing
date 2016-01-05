import React from 'react';
import { map } from 'lodash';

export default class SkusBarcodeTable extends React.Component {
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
        <td>{barcode.barcode}</td>
      </tr>
    );
  }
}
