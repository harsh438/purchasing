import React from 'react';

class PurchaseOrderTableHeader extends React.Component {
  render () {
    return (
      <thead>
        <tr>
          <th colSpan="2">&nbsp;</th>
          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>Product</th>
          <th colSpan="6" style={{ borderLeft: '2px solid #ddd' }}>Ordered</th>
          <th colSpan="4" style={{ borderLeft: '2px solid #ddd' }}>Delivered</th>
          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>Cancelled</th>
          <th colSpan="6" style={{ borderLeft: '2px solid #ddd' }}>Other</th>
        </tr>

        <tr>
          <th>PO #</th>
          <th>Status</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>PID</th>
          <th>Product</th>
          <th>SKU</th>
          <th>Unit Price</th>
          <th>Size</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Order #</th>
          <th>Date</th>
          <th>Type</th>
          <th>Units</th>
          <th>Cost</th>
          <th>Value</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Date</th>
          <th>Units</th>
          <th>Cost</th>
          <th>Value</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Units</th>
          <th>Cost</th>
          <th>Value</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Operator</th>
          <th>Weeks on Sale</th>
          <th>Closing</th>
          <th>Brand Size</th>
          <th>Gender</th>
          <th>Comment</th>
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
        <td>{this.props.purchaseOrder.status}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.productId}
        </td>
        <td>{this.props.purchaseOrder.productName}</td>
        <td>{this.props.purchaseOrder.productSKU || 'n/a'}</td>
        <td>{this.props.purchaseOrder.productCost}</td>
        <td>{this.props.purchaseOrder.productSize}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.orderId}
        </td>
        <td>{this.props.purchaseOrder.orderDate}</td>
        <td>{this.props.purchaseOrder.orderType}</td>
        <td>{this.props.purchaseOrder.orderedUnits}</td>
        <td>{this.props.purchaseOrder.orderedCost}</td>
        <td>{this.props.purchaseOrder.orderedValue}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.deliveryDate}
        </td>
        <td>{this.props.purchaseOrder.deliveredUnits}</td>
        <td>{this.props.purchaseOrder.deliveredCost}</td>
        <td>{this.props.purchaseOrder.deliveredValue}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.cancelledUnits || 'n/a'}
        </td>
        <td>{this.props.purchaseOrder.cancelledCost || 'n/a'}</td>
        <td>{this.props.purchaseOrder.cancelledValue || 'n/a'}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.operator}
        </td>
        <td>{this.props.purchaseOrder.closingDate}</td>
        <td>{this.props.purchaseOrder.weeksOnSale}</td>
        <td>{this.props.purchaseOrder.brandSize}</td>
        <td>{this.props.purchaseOrder.gender}</td>
        <td>{this.props.purchaseOrder.comment}</td>
      </tr>
    );
  }
}

export default class PurchaseOrdersTable extends React.Component {
  render () {
    return (
      <div className="purchase_orders_table">
        <table className="table" style={{ minWidth: '1500px' }}>
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
