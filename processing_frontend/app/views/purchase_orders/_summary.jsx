import React from 'react';
import { isEmptyObject } from '../../utilities/inspection';

export default class PurchaseOrdersSummary extends React.Component {
  render () {
    let summary = this.props.summary;

    if (isEmptyObject(summary)) {
      return (<div></div>);
    }

    return (
      <div className="purchase_orders_summary">
        <table className="purchase_orders_summary__table">
          <tbody>
            <tr>
              <th>&nbsp;</th>
              <th className="text-right">Ordered</th>
              <th className="text-right">Delivered</th>
              <th className="text-right">Cancelled</th>
              <th className="text-right">Balance</th>
            </tr>
            <tr>
              <th>Quantity</th>
              <td>{this.renderNormalFontWeight(summary.orderedQuantity)}</td>
              <td>{this.renderNormalFontWeight(summary.deliveredQuantity)}</td>
              <td>{this.renderNormalFontWeight(summary.cancelledQuantity)}</td>
              <td>{this.renderNormalFontWeight(summary.balanceQuantity)}</td>
            </tr>
            <tr>
              <th>Cost</th>
              <td>{this.renderNormalFontWeight(summary.orderedCost)}</td>
              <td>{this.renderNormalFontWeight(summary.deliveredCost)}</td>
              <td>{this.renderNormalFontWeight(summary.cancelledCost)}</td>
              <td>{this.renderNormalFontWeight(summary.balanceCost)}</td>
            </tr>
            <tr>
              <th>Value</th>
              <td>{this.renderNormalFontWeight(summary.orderedValue)}</td>
              <td>{this.renderNormalFontWeight(summary.deliveredValue)}</td>
              <td>{this.renderNormalFontWeight(summary.cancelledValue)}</td>
              <td>{this.renderNormalFontWeight(summary.balanceValue)}</td>
            </tr>
          </tbody>
        </table>
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
