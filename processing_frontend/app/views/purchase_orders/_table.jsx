import React from 'react';

class PurchaseOrderTableHeader extends React.Component {
  render () {
    return (
      <thead>
        <tr>
          <th colSpan="1">&nbsp;</th>
          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>Product</th>
          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>Order</th>
          <th colSpan="1" style={{ borderLeft: '2px solid #ddd' }}>Other</th>
        </tr>

        <tr>
          <th>PO #</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>PID</th>
          <th>Product</th>
          <th>SKU</th>
          <th>Unit Price</th>
          <th>Size</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>#</th>
          <th>units</th>
          <th>cost</th>
          <th>value</th>
          <th>first received</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Operator</th>
        </tr>
      </thead>
    );
  }
}

class PurchaseOrderRow extends React.Component {
  render () {
    return (
      <tr className={this.props.alt ? 'active' : ''}>
        <td>{this.props.purchaseOrder.poNumber}</td>

        <td>{this.props.purchaseOrder.productId}</td>
        <td>{this.props.purchaseOrder.productName}</td>
        <td>{this.props.purchaseOrder.productSKU}</td>
        <td>{this.props.purchaseOrder.productCost}</td>
        <td>{this.props.purchaseOrder.productSize}</td>

        <td>{this.props.purchaseOrder.orderId}</td>
        <td>n/a</td>
        <td>n/a</td>
        <td>n/a</td>
        <td>n/a</td>

        <td>{this.props.purchaseOrder.operator}</td>
      </tr>
    );
  }
}

export default class PurchaseOrdersTable extends React.Component {
  render () {
    return (
      <div className="purchase_orders_table">
        <table className="table">
          <PurchaseOrderTableHeader />

          <tbody>{this.rows()}</tbody>
        </table>
      </div>
    );
  }

  rows () {
    let currentPoNumber;
    let alt = true;

    return this.props.purchaseOrders.map(function (purchaseOrder) {
      if (currentPoNumber !== purchaseOrder.poNumber) {
        currentPoNumber = purchaseOrder.poNumber;
        alt = !alt;
      }

      return (
        <PurchaseOrderRow alt={alt}
                          key={purchaseOrder.orderId}
                          purchaseOrder={purchaseOrder} />
      );
    });
  }
}
