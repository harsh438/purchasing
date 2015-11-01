import React from 'react';

class PurchaseOrderTableHeader extends React.Component {
  componentWillMount () {
    this.state = {};
    this.onScroll();
    window.addEventListener('scroll', this.onScroll.bind(this));
  }

  shouldComponentUpdate (nextProps, nextState) {
    return this.state.sticky !== nextState.sticky;
  }

  componentWillUnmount () {
    window.removeEventListener('scroll', this.onScroll.bind(this));
  }

  render () {
    return (
      <thead className={this.className()}>
        <tr>
          <th colSpan="2">&nbsp;</th>

          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>
            Product
          </th>

          <th colSpan="6" style={{ borderLeft: '2px solid #ddd' }}>
            Ordered

            <div style={{ fontWeight: 'normal' }}>Total cost: £1,000</div>
            <div style={{ fontWeight: 'normal' }}>Total value: £10,000</div>
          </th>

          <th colSpan="4" style={{ borderLeft: '2px solid #ddd' }}>
            Delivered

            <div style={{ fontWeight: 'normal' }}>Total cost: £1,000</div>
            <div style={{ fontWeight: 'normal' }}>Total value: £10,000</div>
          </th>

          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>
            Cancelled

            <div style={{ fontWeight: 'normal' }}>Total cost: £1,000</div>
            <div style={{ fontWeight: 'normal' }}>Total value: £10,000</div>
          </th>

          <th colSpan="6" style={{ borderLeft: '2px solid #ddd' }}>
            Other
          </th>
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

  onScroll () {
    let newState = { x: window.pageXOffset, y: window.pageYOffset };

    if (!this.state.sticky && this.shouldStick()) {
      newState.sticky = true;
    } else if (this.state.sticky && !this.shouldStick()) {
      newState.sticky = false;
    }

    this.setState(newState);
  }

  shouldStick () {
    return window.pageYOffset > 200;
  }

  className () {
    let className = 'purchase_orders_table__thead';

    if (this.state.sticky) {
      className += '--sticky';
    }

    return className;
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
