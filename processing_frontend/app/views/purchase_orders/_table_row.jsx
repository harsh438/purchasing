import React from 'react';

export default class PurchaseOrderRow extends React.Component {
  render () {
    return (
      <tr className={this.props.alt ? 'active' : ''} ref="row">
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
          {this.props.purchaseOrder.balanceUnits || 'n/a'}
        </td>
        <td>{this.props.purchaseOrder.balanceCost || 'n/a'}</td>
        <td>{this.props.purchaseOrder.balanceValue || 'n/a'}</td>

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
