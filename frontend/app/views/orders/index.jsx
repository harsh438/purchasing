import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersTable } from './_table';
import NumberedPagination from '../pagination/_numbered';
import OrdersForm from './_form';
import { loadOrders, createOrder, exportOrders } from '../../actions/orders';

class OrdersIndex extends React.Component {
  componentWillMount() {
    this.state = { creatingOrder: false,
                   exportingOrders: false,
                   selectedOrders: [] };
    this.loadPage(this.props.location.query.page);
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.creatingOrder && nextProps.order) {
      this.props.history.pushState(null, `/orders/${nextProps.order.id}/edit`);
    } else {
      this.setState({ exportingOrders: false });
    }
  }

  render() {
    return (
      <div className="orders_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-4"></div>
          <div className="col-md-2 col-md-offset-6">
            <OrdersForm onCreateOrder={this.handleCreateOrder.bind(this)} />
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <button className="btn btn-warning"
                    disabled={this.isExportButtonDisabled()}
                    onClick={this.handleExportOrders.bind(this)}>
              Generate Purchase Orders
            </button>

            <OrdersTable orders={this.props.orders}
                         query={this.props.location.query}
                         onOrderSelection={this.handleOrderSelection.bind(this)} />

            <NumberedPagination activePage={this.props.activePage}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page) {
    this.props.dispatch(loadOrders(page || 1));
  }

  handleCreateOrder(order) {
    this.setState({ creatingOrder: true });
    this.props.dispatch(createOrder(order));
  }

  handleOrderSelection(selectedOrders) {
    this.setState({ selectedOrders });
  }

  handleExportOrders(orderIds) {
    this.setState({ exportingOrders: true });
    this.props.dispatch(exportOrders(this.state.selectedOrders));
  }

  isExportButtonDisabled() {
    return this.state.exportingOrders || this.state.selectedOrders.length === 0;
  }
}

function applyState({ orders, order }) {
  return assign({}, orders, order);
}

export default connect(applyState)(OrdersIndex);
