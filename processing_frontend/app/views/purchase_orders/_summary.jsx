import React from 'react';

export default class PurchaseOrdersSummary extends React.Component {
  render () {
    const className = `col-md-${this.props.columns}`;
    return (
      <div className={className}>
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Summary</h3>
          </div>

          <div className="panel-body">
            <div className="purchase_orders_summary">
              <table className="table table-striped">
                <thead>
                  <tr>
                    <th>&nbsp;</th>
                    <th colSpan="2" style={{ borderLeft: '2px solid #ddd' }}>Order</th>
                    <th colSpan="2" style={{ borderLeft: '2px solid #ddd' }}>Delivery</th>
                    <th colSpan="2" style={{ borderLeft: '2px solid #ddd' }}>Cancel</th>
                    <th colSpan="2" style={{ borderLeft: '2px solid #ddd' }}>Balance</th>
                  </tr>
                  <tr>
                    <th>&nbsp;</th>
                    <th style={{ borderLeft: '2px solid #ddd' }}>Cost</th>
                    <th>Value</th>
                    <th style={{ borderLeft: '2px solid #ddd' }}>Cost</th>
                    <th>Value</th>
                    <th style={{ borderLeft: '2px solid #ddd' }}>Cost</th>
                    <th>Value</th>
                    <th style={{ borderLeft: '2px solid #ddd' }}>Cost</th>
                    <th>Value</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th>Total</th>
                    <td style={{ borderLeft: '2px solid #ddd' }}>£100</td>
                    <td>£1,000</td>
                    <td style={{ borderLeft: '2px solid #ddd' }}>£100</td>
                    <td>£10,000</td>
                    <td style={{ borderLeft: '2px solid #ddd' }}>£100</td>
                    <td>£1,000</td>
                    <td style={{ borderLeft: '2px solid #ddd' }}>£100</td>
                    <td>£10,000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
