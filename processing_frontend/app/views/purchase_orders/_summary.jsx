import React from 'react';

export default class PurchaseOrdersSummary extends React.Component {
  render () {
    return (
      <div className="row">
        <div className="col-md-2 col-md-offset-2">
          <table className="purchase_orders_summary__table">
            <tbody>
              <tr>
                <th className="text-center" colSpan="2">Ordered</th>
              </tr>
              <tr>
                <th>Quantity</th>
                <td>{this.renderNormalFontWeight(this.props.orderedQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(this.props.orderedCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(this.props.orderedValue)}</td>
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
                <td>{this.renderNormalFontWeight(this.props.deliveredQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(this.props.deliveredCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(this.props.deliveredValue)}</td>
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
                <td>{this.renderNormalFontWeight(this.props.cancelledQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(this.props.cancelledCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(this.props.cancelledValue)}</td>
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
                <td>{this.renderNormalFontWeight(this.props.balanceQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(this.props.balanceCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(this.props.balanceValue)}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  renderNormalFontWeight (value) {
    if (value == null) return;

    return (
      <div style={{ fontWeight: 'normal' }}>{value}</div>
    );
  }
}
