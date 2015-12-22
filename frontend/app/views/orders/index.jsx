import React from 'react';
import { assign, isEqual } from 'lodash';
import { connect } from 'react-redux';
import { OrdersTable } from './_table';
import OrdersFilter from './_filters';
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
    const nextQuery = nextProps.location.query;

    if (this.state.creatingOrder && nextProps.order) {
      this.props.history.pushState(null, `/orders/${nextProps.order.id}/edit`);
    } else if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPage(nextQuery.page, (nextQuery.filters || {}));
    } else {
      this.setState({ exportingOrders: false, selectedOrders: [] });
    }
  }

  render() {
    return (
      <div className="orders_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>Orders</h1>
          </div>

          <div className="col-md-2 col-md-offset-6">
            <OrdersForm onCreateOrder={this.handleCreateOrder.bind(this)} />
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <div className="panel panel-default">
              <div className="panel-body">
                <OrdersFilter filters={this.props.location.query.filters}
                              orderTypes={this.props.orderTypes}
                              onFilterOrders={this.handleFilterOrders.bind(this)} />
              </div>
            </div>
          </div>

          <div className="col-md-12">
            <button className="btn btn-warning"
                    disabled={this.isExportButtonDisabled()}
                    onClick={this.handleExportOrders.bind(this)}>
              Generate Purchase Orders
            </button>

            <hr />

            <OrdersTable orders={this.props.orders}
                         query={this.props.location.query}
                         exportingOrders={this.state.exportingOrders}
                         selectedOrders={this.state.selectedOrders}
                         onOrderSelection={this.handleOrderSelection.bind(this)} />

            <NumberedPagination activePage={this.props.activePage}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page = 1, filters) {
    this.props.dispatch(loadOrders({ page, filters }));
  }

  handleFilterOrders(filters) {
    this.props.history.pushState(null, '/orders', { filters });
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
