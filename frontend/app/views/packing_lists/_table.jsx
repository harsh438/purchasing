import React from 'react';
import { map } from 'lodash';

export default class PackingListsTable extends React.Component {
  render() {
    return (
      <table>
        <thead>
          <tr>
            <th>PO #</th>
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

  renderRow({ purchaseOrderId, url }) {
    return (
      <tr>
        <td>{purchaseOrderId}</td>
        <td>{url}</td>
      </tr>
    );
  }
}
