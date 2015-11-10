import { assign } from 'lodash';
import React from 'react';
import { connect } from 'react-redux';

class OrdersIndex extends React.Component {
  render() {
    return (
      <div className="orders_index">

      </div>
    );
  }
}

function applyState({ filters, orders }) {
  return assign({}, filters, orders);
}

export default connect(applyState)(OrdersIndex);
