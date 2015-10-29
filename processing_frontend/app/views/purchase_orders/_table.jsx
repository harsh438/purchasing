import React from 'react';

class PurchaseOrderRow extends React.Component {
  render () {
    const productId = this.props.purchaseOrder.product_id;
    const productName = this.props.purchaseOrder.product_name;

    return (
      <tr>
        <td>{productId}</td>
        <td>{productName}</td>
      </tr>
    );
  }
}

export default class PurchaseOrdersTable extends React.Component {
  render () {
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th style={{ width: '10%' }}>Product ID</th>
            <th>Product Name</th>
          </tr>
        </thead>
        <tbody>{this.rows()}</tbody>
      </table>
    );
  }

  rows () {
    return this.props.purchaseOrders.map(function (purchaseOrder) {
      return (
        <PurchaseOrderRow key={purchaseOrder.id} purchaseOrder={purchaseOrder} />
      );
    });
  }
}
