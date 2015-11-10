import React from 'react';
import { loadOrders } from '../../actions/orders'

export class OrdersList extends React.Component {
  componentWillMount () {
    loadOrders();
  }

  render() {
    return (
      <div className="orders_list">

      </div>
    );
  }
}
