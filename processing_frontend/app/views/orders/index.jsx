import React from 'react';

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
