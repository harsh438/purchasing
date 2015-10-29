import React from 'react';

class PurchaseOrderRow extends React.Component {
  render () {
    const orderId = this.props.purchaseOrder.id;
    const poNumber = this.props.purchaseOrder.summary_id;
    const productId = this.props.purchaseOrder.product_id;
    const productName = this.props.purchaseOrder.product_name;
    const productSKU = this.props.purchaseOrder.product_sku;
    const productCost = this.props.purchaseOrder.cost;
    const productSize = this.props.purchaseOrder.product_size;
    const operator = this.props.purchaseOrder.operator;

    return (
      <tr>
        <td>{orderId}</td>
        <td>{poNumber}</td>
        <td>{productId}</td>
        <td>{productName}</td>
        <td>{productSKU}</td>
        <td>{productCost}</td>
        <td>{productSize}</td>
        <td>{operator}</td>
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
        <PurchaseOrderRow key={purchaseOrder.id}
                          purchaseOrder={purchaseOrder} />
      );
    });
  }
}
