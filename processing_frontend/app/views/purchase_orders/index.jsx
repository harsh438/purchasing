import React from 'react';
import { connect } from 'react-redux';
import fetchPurchaseOrders from '../../actions/fetch_purchase_orders';
import PurchaseOrdersTable from './_table';
import PurchaseOrdersForm from './_form';
import PurchaseOrdersSummary from './_summary';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount() {
    this.loadPurchaseOrders(1);
  }

  render () {
    console.log(this.props);
    const purchaseOrders = this.props.purchaseOrders;
    const nextPage = this.props.page + 1;

    return (
      <div className="purchase_orders_index">
        <div className="container-fluid">
          <div className="row">
            <PurchaseOrdersForm columns="6" />
            <PurchaseOrdersSummary columns="6" />
          </div>
        </div>

        <PurchaseOrdersTable purchaseOrders={purchaseOrders} />

        <button className="btn btn-default btn-lg"
                style={{ width: '100%' }}
                onClick={this.loadPurchaseOrders.bind(this, nextPage)}>
          Load More Orders
        </button>
      </div>
    );
  }

  loadPurchaseOrders (page) {
    this.props.dispatch(fetchPurchaseOrders(page));
  }
}

function applyState({ purchaseOrders }) {
  return purchaseOrders;
}

export default connect(applyState)(PurchaseOrdersIndex);
