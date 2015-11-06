import React from 'react';
import { isEmptyObject } from '../../utilities/inspection';

export default class PurchaseOrdersSummary extends React.Component {
  render () {
    let summary = this.props.summary;

    if (isEmptyObject(summary)) {
      return (<div></div>);
    }

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
                <td>{this.renderNormalFontWeight(summary.orderedQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(summary.orderedCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(summary.orderedValue)}</td>
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
                <td>{this.renderNormalFontWeight(summary.deliveredQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(summary.deliveredCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(summary.deliveredValue)}</td>
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
                <td>{this.renderNormalFontWeight(summary.cancelledQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(summary.cancelledCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(summary.cancelledValue)}</td>
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
                <td>{this.renderNormalFontWeight(summary.balanceQuantity)}</td>
              </tr>
              <tr>
                <th>Cost</th>
                <td>{this.renderNormalFontWeight(summary.balanceCost)}</td>
              </tr>
              <tr>
                <th>Value</th>
                <td>{this.renderNormalFontWeight(summary.balanceValue)}</td>
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
