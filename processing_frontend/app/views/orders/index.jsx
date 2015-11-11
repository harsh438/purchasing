import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersTable } from './_table';
import { loadOrders, createOrder, exportOrders } from '../../actions/orders';

class OrdersIndex extends React.Component {
  componentWillMount () {
    this.state = { creatingOrder: false };
    this.props.dispatch(loadOrders());
  }

  componentWillReceiveProps (nextProps) {
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
            <div className="panel panel-default">
              <div className="panel-heading">
                <h3 className="panel-title">Create a re-order</h3>
              </div>

              <div className="panel-body">
                <button className="btn btn-success"
                        onClick={this.dispatchCreateOrder.bind(this)}
                        disabled={this.state.creatingOrder}>
                  Create order
                </button>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <OrdersTable orders={this.props.orders}
                         onExportOrders={this.dispatchExportOrder.bind(this)} />
          </div>
        </div>
      </div>
    );
  }

  dispatchCreateOrder () {
    this.setState({ creatingOrder: true });
    this.props.dispatch(createOrder());
  }

  dispatchExportOrder (orderIds) {
    this.props.dispatch(exportOrders(orderIds));
  }
}

function applyState({ orders, order }) {
  return assign({}, orders, order);
}

export default connect(applyState)(OrdersIndex);
