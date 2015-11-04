import React from 'react';

export default class PurchaseOrderRow extends React.Component {
  render () {
    return (
      <tr className={this.props.alt ? 'active' : ''} ref="row">
        <td>
          <input type="checkbox"
                 name="selected"
                 ref="selected"
                 onChange={this.handleChange.bind(this, 'selected')}
                 value={this.props.purchaseOrder.id}
                 style={{ margin: '7px auto 0', display: 'block' }} />
        </td>
        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.poNumber}
        </td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.productId}
        </td>
        <td>{this.props.purchaseOrder.productName}</td>
        <td>{this.props.purchaseOrder.productSku}</td>
        <td>{this.props.purchaseOrder.productCost}</td>
        <td>{this.props.purchaseOrder.productSize}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.orderDate}
        </td>
        <td>{this.props.purchaseOrder.orderType}</td>
        <td>{this.props.purchaseOrder.orderedQuantity}</td>
        <td>{this.props.purchaseOrder.orderedCost}</td>
        <td>{this.props.purchaseOrder.orderedValue}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.deliveryDate}
        </td>
        <td>{this.props.purchaseOrder.dropNumber}</td>
        <td>{this.props.purchaseOrder.deliveredQuantity}</td>
        <td>{this.props.purchaseOrder.deliveredCost}</td>
        <td>{this.props.purchaseOrder.deliveredValue}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.cancelledQuantity}
        </td>
        <td>{this.props.purchaseOrder.cancelledCost}</td>
        <td>{this.props.purchaseOrder.cancelledValue}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.balanceQuantity}
        </td>
        <td>{this.props.purchaseOrder.balanceCost}</td>
        <td>{this.props.purchaseOrder.balanceValue}</td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.brandSize}
        </td>
        <td>{this.props.purchaseOrder.gender}</td>
      </tr>
    );
  }

  handleChange (field, { target }) {
    if (target.checked) {
      this.props.table.selectRow(target.value)
    } else {
      this.props.table.unSelectRow(target.value)
    }
  }
}
