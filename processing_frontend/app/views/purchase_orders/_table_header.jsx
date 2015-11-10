import React from 'react';
import PurchaseOrdersSummaryLink from './_summary_link';

export default class PurchaseOrderTableHeader extends React.Component {
  render () {
    return (
      <thead ref="thead">
        <tr>
          <th colSpan="2">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          </th>

          <th colSpan="8" style={{ borderLeft: '2px solid #ddd' }}>
            Product
          </th>

          <th colSpan="4" style={{ borderLeft: '2px solid #ddd' }}>
            <PurchaseOrdersSummaryLink summary={this.props.summary}>
              Ordered
            </PurchaseOrdersSummaryLink>
          </th>

          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>
            <PurchaseOrdersSummaryLink summary={this.props.summary}>
              Delivered
            </PurchaseOrdersSummaryLink>
          </th>

          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>
            <PurchaseOrdersSummaryLink summary={this.props.summary}>
              Cancelled
            </PurchaseOrdersSummaryLink>
          </th>

          <th colSpan="3" style={{ borderLeft: '2px solid #ddd' }}>
            <PurchaseOrdersSummaryLink summary={this.props.summary}>
              Balance
            </PurchaseOrdersSummaryLink>
          </th>
        </tr>

        <tr ref="row" className="scaled">
          <th className="narrow"><input type="checkbox"
                     style={{ display: 'block', margin: '7px auto 0' }}
                     onClick={this.props.onSelectAll} /></th>
          <th style={{ borderLeft: '2px solid #ddd' }}>PO #</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>PID</th>
          <th className="x-wide">Product</th>
          <th className="wideish">SKU</th>
          <th>Cost</th>
          <th>RRP</th>
          <th className="narrowish">Size</th>
          <th title="Brand Size">Br. Size</th>
          <th>Gender</th>

          <th className="wide" style={{ borderLeft: '2px solid #ddd' }}>Type</th>
          <th className="narrowish">Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th className="wideish" style={{ borderLeft: '2px solid #ddd' }}>Date</th>
          <th>Drop #</th>
          <th className="narrowish">Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th className="narrowish" style={{ borderLeft: '2px solid #ddd' }}>Qty</th>
          <th>Cost</th>
          <th>Val</th>

          <th className="narrowish" style={{ borderLeft: '2px solid #ddd' }}>Qty</th>
          <th>Cost</th>
          <th className="wideish">Val</th>
        </tr>
      </thead>
    );
  }
}
