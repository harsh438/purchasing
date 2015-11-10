import React from 'react';
import { map } from 'lodash';
import { OrderRow } from './_order_row'

export class OrdersTable extends React.Component {
  render() {
    return (
      <div className="orders_table">
        <table className="table">
          <thead>
            <tr>
              <th>Id</th>
              <th>Status</th>
              <th>Created</th>
              <th>Updated</th>
            </tr>
          </thead>
          <tbody>
            {this.renderRows()}
          </tbody>
        </table>
      </div>
    );
  }

  renderRows() {
    return map(this.props.orders, (order) => {
      return (
        <OrderRow id={order.id}
                  status={order.status}
                  createdAt={order.createdAt}
                  updatedAt={order.updatedAt} />
      );
    });
  }
}
