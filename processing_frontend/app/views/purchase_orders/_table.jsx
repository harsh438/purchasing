import React from 'react';

class PurchaseOrderRow extends React.Component {
  render () {
    return (
      <tr>
        <td>{this.props.purchaseOrder.orderId}</td>
        <td>{this.props.purchaseOrder.poNumber}</td>
        <td>{this.props.purchaseOrder.productId}</td>
        <td>{this.props.purchaseOrder.productName}</td>
        <td>{this.props.purchaseOrder.productSKU}</td>
        <td>{this.props.purchaseOrder.productCost}</td>
        <td>{this.props.purchaseOrder.productSize}</td>
        <td>{this.props.purchaseOrder.operator}</td>
      </tr>
    );
  }
}

export default class PurchaseOrdersTable extends React.Component {
  render () {
    return (
      <div className="purchase_orders_table">
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Order #</th>
              <th>PO #</th>
              <th>PID</th>
              <th>Product</th>
              <th>SKU</th>
              <th>Unit Price</th>
              <th>Size</th>
              <th>Operator</th>
            </tr>
          </thead>
          <tbody>{this.rows()}</tbody>
        </table>
      </div>
    );
  }

  rows () {
    return this.props.purchaseOrders.map(function (purchaseOrder) {
      return (
        <PurchaseOrderRow key={purchaseOrder.orderId}
                          purchaseOrder={purchaseOrder} />
      );
    });
  }
}
