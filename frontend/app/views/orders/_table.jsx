import React from 'react';
import { contains, map, reject } from 'lodash';
import OrdersTableRow from './_table_row';
import { loadOrders } from '../../actions/orders';

export class OrdersTable extends React.Component {
  componentWillMount() {
    this.state = { selectedOrders: [] };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ selectedOrders: [] });
  }

  render() {
    return (
      <div className="orders_table">
        <table className="table">
          <thead>
            <tr>
              <th style={{ width: '5%' }}>&nbsp;</th>
              <th>Order name</th>
              <th className="text-center" style={{ width: '15%' }}># of Products</th>
              <th className="text-center" style={{ width: '15%' }}>Created</th>
              <th className="text-center" style={{ width: '15%' }}>Exported</th>
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
        <OrdersTableRow key={order.id}
                        onToggleCheck={this.toggleOrderSelection.bind(this)}
                        {...order} />
      );
    });
  }

  toggleOrderSelection(orderId) {
    let selectedOrders;

    if (contains(this.state.selectedOrders, orderId)) {
      selectedOrders = reject(this.state.selectedOrders, (id) => id === orderId);
    } else {
      selectedOrders = [...this.state.selectedOrders, orderId];
    }

    this.setState({ selectedOrders });
    this.props.onOrderSelection(selectedOrders);
  }
}
