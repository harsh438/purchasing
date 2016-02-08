import React from 'react';
import { map } from 'lodash';

export default class PackingListsTable extends React.Component {
  render() {
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>GRN</th>
            <th>PO Numbers</th>
            <th>Delivery date</th>
            <th>Packing list</th>
          </tr>
        </thead>
        <tbody>
          {this.renderRows()}
        </tbody>
      </table>
    );
  }

  renderRows() {
    return map(this.props.packingLists, this.renderRow, this);
  }

  renderRow({ grn, deliveryDate, purchaseOrderIds, url }) {
    return (
      <tr key={[grn, url]}>
        <td>{grn}</td>
        <td>{purchaseOrderIds.join(', ')}</td>
        <td>{deliveryDate}</td>
        <td><a href={url} target="_blank">{url}</a></td>
      </tr>
    );
  }
}
