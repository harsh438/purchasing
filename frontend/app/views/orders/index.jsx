import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersTable } from './_table';
import NumberedPagination from '../pagination/_numbered';
import { loadOrders, createOrder, exportOrders } from '../../actions/orders';

class OrdersIndex extends React.Component {
  componentWillMount() {
    this.state = { creatingOrder: false };
    this.loadPage(this.props.location.query.page);
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.creatingOrder && nextProps.order) {
      this.props.history.pushState(null, `/orders/${nextProps.order.id}/edit`);
    }
  }

  render() {
    return (
      <div className="orders_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-12">
            <OrdersTable orders={this.props.orders}
                         query={this.props.location.query}
                         onCreateOrder={this.handleCreateOrder.bind(this)}
                         onExportOrders={this.handleExportOrder.bind(this)} />

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

  handleExportOrder(orderIds) {
    this.props.dispatch(exportOrders(orderIds));
  }
}

function applyState({ orders, order }) {
  return assign({}, orders, order);
}

export default connect(applyState)(OrdersIndex);
