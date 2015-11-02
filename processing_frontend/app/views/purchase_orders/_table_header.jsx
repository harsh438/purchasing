import React from 'react';

export default class PurchaseOrderTableHeader extends React.Component {
  componentDidMount () {
    this.fixCellWidths();
  }

  render () {
    return (
      <thead style={{ width: this.props.width }}>
        <tr>
          <th colSpan="2">
            {this.renderExportUrl()}
          </th>

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

          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>
            Balance

            <div style={{ fontWeight: 'normal' }}>Total cost: £1,000</div>
            <div style={{ fontWeight: 'normal' }}>Total value: £10,000</div>
          </th>

          <th colSpan="6" style={{ borderLeft: '2px solid #ddd' }}>
            Other
          </th>
        </tr>

        <tr ref="row">
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
          <th>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Date</th>
          <th>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Qty</th>
          <th>Cost</th>
          <th>Val</th>

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

  renderExportUrl () {
    if (!this.props.exportable) return;

    if (this.props.exportable.url) {
      return (
        <a href={this.props.exportable.url} target="_blank">export as .csv</a>
      );
    } else if (this.props.exportable.massive) {
      return (
        <strong>Result set too big to export :(</strong>
      );
    }
  }

  fixCellWidths () {
    for (let i = 0; i < this.refs.row.children.length; i++) {
      this.refs.row.children[i].style.width = this.props.cellWidths[i];
    }
  }
}
