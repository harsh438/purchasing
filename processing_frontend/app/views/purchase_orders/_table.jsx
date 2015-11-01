import React from 'react';
import PurchaseOrderTableHeader from './_table_header';
import PurchaseOrderRow from './_table_row';

export default class PurchaseOrdersTable extends React.Component {
  render () {
    return (
      <div className="purchase_orders_table">
        <table className="table" style={{ minWidth: '1500px' }}>
          <PurchaseOrderTableHeader />

          <tbody>{this.rows()}</tbody>
        </table>
      </div>
    );
  }

  rows () {
    let currentPoNumber;
    let alt = true;

    return this.props.purchaseOrders.map(function (purchaseOrder) {
      if (currentPoNumber !== purchaseOrder.poNumber) {
        currentPoNumber = purchaseOrder.poNumber;
        alt = !alt;
      }

      return (
        <PurchaseOrderRow alt={alt}
                          key={purchaseOrder.orderId}
                          purchaseOrder={purchaseOrder} />
      );
    });
  }
}
