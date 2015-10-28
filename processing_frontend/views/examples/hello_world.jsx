import React from 'react';
import { connect } from 'react-redux';
import fetchPurchaseOrders from '../../actions/fetch_purchase_orders';
import PurchaseOrdersTable from '../purchase_orders/table';

class HelloWorld extends React.Component {
  componentWillMount() {
    this.loadPurchaseOrders(1);
  }

  render () {
    const purchaseOrders = this.props.purchaseOrders.pages[this.props.purchaseOrders.page];

    return (
      <div className="hello_world">
        <h1>Hello World {this.props.purchaseOrders.page}</h1>

        <button onClick={this.loadPurchaseOrders.bind(this, 2)}>
          Load Orders
        </button>

        <PurchaseOrdersTable purchaseOrders={purchaseOrders} />
      </div>
    );
  }

  loadPurchaseOrders (page) {
    this.props.dispatch(fetchPurchaseOrders(page));
  }
}

function applyState({ purchaseOrders }) {
  return { purchaseOrders };
}

export default connect(applyState)(HelloWorld);
