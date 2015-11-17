import React from 'react';
import { contains, map, reject } from 'lodash';
import { OrdersTableRow } from './_table_row';
import NumberedPagination from '../pagination/_numbered';
import { loadOrders } from '../../actions/orders';

export class OrdersTable extends React.Component {
  componentWillMount () {
    this.state = { exportingOrders: false,
                   selectedOrders: [] };
  }

  componentWillReceiveProps (nextProps) {
    this.setState({ exportingOrders: false,
                    selectedOrders: [] });
  }

  render() {
    return (
      <div>
        <div className="panel panel-default">
          <div className="panel-body">
            <button className="btn btn-warning"
                    disabled={this.isExportButtonDisabled()}
                    onClick={this.handleExportOrders.bind(this)}>
              Create Purchase Orders
            </button>
          </div>
        </div>

        <div className="panel panel-default">
          <div className="panel-body">
            <div className="orders_table">
              <table className="table">
                <thead>
                  <tr>
                    <th style={{ width: '5%' }}>&nbsp;</th>
                    <th>Order</th>
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

          <NumberedPagination loadPage={this.loadPage}
                              pages={this.props.pages} />
        </div>
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

  toggleOrderSelection (orderId) {
    let selectedOrders;

    if (contains(this.state.selectedOrders, orderId)) {
      selectedOrders = reject(this.state.selectedOrders, (id) => id === orderId);
    } else {
      selectedOrders = [...this.state.selectedOrders, orderId];
    }

    this.setState({ selectedOrders });
  }

  handleExportOrders () {
    this.setState({ exportingOrders: true });
    this.props.onExportOrders(this.state.selectedOrders);
  }

  loadPage(number) {
    this.props.dispatch(loadOrders(number));
  }

  isExportButtonDisabled () {
    return this.state.exportingOrders || this.state.selectedOrders.length === 0;
  }
}
