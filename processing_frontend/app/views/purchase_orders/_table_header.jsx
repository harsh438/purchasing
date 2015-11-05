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
            <PurchaseOrdersSummary {...this.props.summary} />
          </th>

          <th colSpan="4" className="text-right" style={{ verticalAlign: 'bottom' }}>
            {this.renderExportButton()}
          </th>
        </tr>

        <tr>
          <th colSpan="2">
            {this.props.totalCount} results
          </th>

          <th colSpan="6" style={{ borderLeft: '2px solid #ddd' }}>
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

          <th colSpan="2" style={{ borderLeft: '2px solid #ddd' }}>
            &nbsp;
          </th>
        </tr>

        <tr ref="row">
          <th>&nbsp;</th>
          <th style={{ borderLeft: '2px solid #ddd' }}>PO #</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>PID</th>
          <th>Product</th>
          <th>SKU</th>
          <th>Unit Price</th>
          <th>RRP</th>
          <th>Size</th>

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

          <th style={{ borderLeft: '2px solid #ddd' }}>Brand Size</th>
          <th>Gender</th>
        </tr>
      </thead>
    );
  }

  renderExportButton () {
    if (!this.props.exportable) return;

    if (this.props.exportable.url) {
      return (
        <a href={this.props.exportable.url}
           className="btn btn-default btn-sm pull-right"
           target="_blank">
          export as .csv
        </a>
      );
    } else if (this.props.exportable.massive) {
      return (
        <span style={{ fontWeight: 'normal' }}>Result set too big to export :(</span>
      );
    }
  }

  fixCellWidths () {
    for (let i = 0; i < this.refs.row.children.length; i++) {
      this.refs.row.children[i].style.width = this.props.cellWidths[i];
    }
  }
}
