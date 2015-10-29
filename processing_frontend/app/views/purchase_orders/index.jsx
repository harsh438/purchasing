import React from 'react';
import { connect } from 'react-redux';
import fetchPurchaseOrders from '../../actions/fetch_purchase_orders';
import fetchBrands from '../../actions/fetch_brands';
import PurchaseOrdersTable from './_table';
import PurchaseOrdersForm from './_form';
import PurchaseOrdersSummary from './_summary';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount() {
    this.fetchBrands();
    this.fetchPurchaseOrders(1);
  }

  render () {
    const purchaseOrders = this.props.purchaseOrders;
    const nextPage = this.props.page + 1;

    return (
      <div className="purchase_orders_index">
        <div className="row">
          <PurchaseOrdersForm brands={this.props.brands}
                              columns="6"
                              currentBrand={this.props.location.query.brand} />
                            
          <PurchaseOrdersSummary columns="6" />
        </div>

        <PurchaseOrdersTable purchaseOrders={purchaseOrders} />

        <button className="btn btn-default btn-lg"
                style={{ width: '100%' }}
                onClick={this.fetchPurchaseOrders.bind(this, nextPage)}>
          Load More Orders
        </button>
      </div>
    );
  }

  fetchBrands (page) {
    this.props.dispatch(fetchBrands());
  }

  fetchPurchaseOrders (page) {
    this.props.dispatch(fetchPurchaseOrders(this.props.location.query, page));
  }
}

function applyState({ brands, purchaseOrders }) {
  return { brands, purchaseOrders: purchaseOrders.purchaseOrders };
}

export default connect(applyState)(PurchaseOrdersIndex);
