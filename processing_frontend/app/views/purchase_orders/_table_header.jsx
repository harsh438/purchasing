import React from 'react';

export default class PurchaseOrderTableHeader extends React.Component {
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
    return window.pageYOffset > 290;
  }

  className () {
    let className = 'purchase_orders_table__thead';

    if (this.state.sticky) {
      className += '--sticky';
    }

    return className;
  }
}
