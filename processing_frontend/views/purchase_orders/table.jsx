import React from 'react';

export default class PurchaseOrdersTable extends React.Component {
  render () {
    const rows = this.props.purchaseOrders.map(function (purchaseOrder, i) {
      return (
        <pre key={i}>
          {JSON.stringify(purchaseOrder, null, 2)}
        </pre>
      );
    });

    return (
      <table>
        <tbody>
          <tr>
            <td>{rows}</td>
          </tr>
        </tbody>
      </table>
    );
  }
}
