import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersHeader } from './_orders_header'
import { OrdersTable } from './_orders_table'
import { loadOrders } from '../../actions/orders'

class OrdersIndex extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadOrders());
  }

  render() {
    return (
      <div className="orders_index container-fluid">
        <div className="row">
          <div className="col-md-12">
            <OrdersHeader />
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
}

function applyState({ orders }) {
  return assign({}, orders);
}

export default connect(applyState)(OrdersIndex);
