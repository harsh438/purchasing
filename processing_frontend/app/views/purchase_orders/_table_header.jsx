import React from 'react';

export default class PurchaseOrderTableHeader extends React.Component {
  componentDidMount () {
    this.fixCellWidths();
  }

  render () {
    return (
      <thead ref="thead" style={{ width: this.props.width }}>
        <tr>
          <th colSpan="20">
            <div className="row">
              <div className="col-md-2 col-md-offset-2">
                <table className="purchase_orders_summary__table">
                  <tbody>
                    <tr>
                      <th className="text-center" colSpan="2">Ordered</th>
                    </tr>
                    <tr>
                      <th>Quantity</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.orderedQuantity)}</td>
                    </tr>
                    <tr>
                      <th>Cost</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.orderedCost)}</td>
                    </tr>
                    <tr>
                      <th>Value</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.orderedValue)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div className="col-md-2">
                <table className="purchase_orders_summary__table">
                  <tbody>
                    <tr>
                      <th className="text-center" colSpan="2">Delivered</th>
                    </tr>
                    <tr>
                      <th>Quantity</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.deliveredQuantity)}</td>
                    </tr>
                    <tr>
                      <th>Cost</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.deliveredCost)}</td>
                    </tr>
                    <tr>
                      <th>Value</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.deliveredValue)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div className="col-md-2">
                <table className="purchase_orders_summary__table">
                  <tbody>
                    <tr>
                      <th className="text-center" colSpan="2">Cancelled</th>
                    </tr>
                    <tr>
                      <th>Quantity</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.cancelledQuantity)}</td>
                    </tr>
                    <tr>
                      <th>Cost</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.cancelledCost)}</td>
                    </tr>
                    <tr>
                      <th>Value</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.cancelledValue)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div className="col-md-2">
                <table className="purchase_orders_summary__table">
                  <tbody>
                    <tr>
                      <th className="text-center" colSpan="2">Balance</th>
                    </tr>
                    <tr>
                      <th>Quantity</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.balanceQuantity)}</td>
                    </tr>
                    <tr>
                      <th>Cost</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.balanceCost)}</td>
                    </tr>
                    <tr>
                      <th>Value</th>
                      <td>{this.renderNormalFontWeight(this.props.summary.balanceValue)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </th>

          <th colSpan="4" className="text-right" style={{ verticalAlign: 'bottom' }}>
            {this.renderExportButton()}
          </th>
        </tr>

        <tr>
          <th colSpan="1">
            {this.props.totalCount} results
          </th>

          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>
            Product
          </th>

          <th colSpan="5" style={{ borderLeft: '2px solid #ddd' }}>
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
          <th>PO #</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>PID</th>
          <th>Product</th>
          <th>SKU</th>
          <th>Unit Price</th>
          <th>Size</th>

          <th style={{ borderLeft: '2px solid #ddd' }}>Date</th>
          <th>Type</th>
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

  renderNormalFontWeight (value) {
    if (value == null) return;

    return (
      <div style={{ fontWeight: 'normal' }}>{value}</div>
    );
  }

  fixCellWidths () {
    for (let i = 0; i < this.refs.row.children.length; i++) {
      this.refs.row.children[i].style.width = this.props.cellWidths[i];
    }
  }
}
