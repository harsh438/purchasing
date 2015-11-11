import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersTable } from './_table';
import { loadOrders, createOrder } from '../../actions/orders';

class OrdersIndex extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadOrders());
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
                        onClick={this.dispatchCreateOrder.bind(this)}>
                  Create order
                </button>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <OrdersTable orders={this.props.orders} />
          </div>
        </div>
      </div>
    );
  }

  dispatchCreateOrder () {
    this.props.dispatch(createOrder());
  }
}

function applyState({ orders }) {
  return orders;
}

export default connect(applyState)(OrdersIndex);
