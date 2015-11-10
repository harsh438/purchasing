import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersHeader } from './_orders_header'
import { OrdersList } from './_orders_list'

class OrdersIndex extends React.Component {
  render() {
    return (
      <div className="orders_index">
        <OrdersHeader />
        <OrdersList />
      </div>
    );
  }
}

function applyState({ filters, orders }) {
  return assign({}, filters, orders);
}

export default connect(applyState)(OrdersIndex);
