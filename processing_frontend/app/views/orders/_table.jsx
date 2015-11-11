import React from 'react';
import { map } from 'lodash';
import { OrdersTableRow } from './_table_row';

export class OrdersTable extends React.Component {
  render() {
    return (
      <div className="panel panel-default"
           style={{ marginTop: '70px' }}>
        <div className="panel-heading">
          <h3 className="panel-title">Shopping lists</h3>
        </div>

        <div className="panel-body">
          <div className="orders_table">
            <table className="table">
              <thead>
                <tr>
                  <th>List</th>
                  <th className="text-center" style={{ width: '20%' }}>Created</th>
                  <th className="text-center" style={{ width: '20%' }}>Exported</th>
                </tr>
              </thead>

              <tbody>
                {this.renderRows()}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }

  renderRows() {
    return map(this.props.orders, function (order) {
      return (
        <OrdersTableRow key={order.id} {...order} />
      );
    });
  }
}
