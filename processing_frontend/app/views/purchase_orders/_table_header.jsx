import React from 'react';
import PurchaseOrdersSummary from './_summary';

export default class PurchaseOrderTableHeader extends React.Component {
  componentDidMount () {
    this.fixCellWidths();
  }

  render () {
    return (
      <thead ref="thead" style={{ width: this.props.width }}>
        <tr>
          <th colSpan="20">
            <PurchaseOrdersSummary summary={this.props.summary} />
          </th>

          <th colSpan="3" className="text-right" style={{ verticalAlign: 'bottom' }}>

          </th>
        </tr>

        <tr>
          <th colSpan="2">

          </th>

          <th colSpan="8" style={{ borderLeft: '2px solid #ddd' }}>
            Product
          </th>

          <th colSpan="4" style={{ borderLeft: '2px solid #ddd' }}>
            Ordered
          </th>

          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>
            Delivered
          </th>

          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>
            Cancelled
          </th>

          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>
            Balance
          </th>
        </tr>

        <tr ref="row">
          <th><input type="checkbox"
                     style={{ display: 'block', margin: '7px auto 0' }}
                     onClick={this.props.onSelectAll} /></th>
          <th style={{ borderLeft: '2px solid #ddd' }}>PO #</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>PID</th>
          <th>Product</th>
          <th>SKU</th>
          <th>Unit Price</th>
          <th>RRP</th>
          <th>Size</th>
          <th>Brand Size</th>
          <th>Gender</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Type</th>
          <th>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Date</th>
          <th>Drop #</th>
          <th>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Qty</th>
          <th>Cost</th>
          <th>Val</th>
        </tr>
      </thead>
    );
  }

  fixCellWidths () {
    for (let i = 0; i < this.refs.row.children.length; i++) {
      this.refs.row.children[i].style.width = this.props.cellWidths[i];
    }
  }
}
