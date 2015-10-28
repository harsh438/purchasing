import React from 'react';

export default class PurchaseOrdersTable extends React.Component {
  render () {
    const rows = [];

    for (let i in this.props.purchaseOrders) {
      rows.push((<pre>{JSON.stringify(this.props.purchaseOrders[i], null, 2)}</pre>));
    }

    return (<table><tr><td>{rows}</td></tr></table>);
  }
}
