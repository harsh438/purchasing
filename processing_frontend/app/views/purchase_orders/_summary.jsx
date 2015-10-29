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
            <div className="purchase_orders_stats">
              <table className="table table-striped">
                <thead>
                  <tr>
                    <th>Total</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th>100</th>
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
