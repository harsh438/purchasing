import React from 'react';
import { connect } from 'react-redux';
import { loadPurchaseOrders, loadMorePurchaseOrders } from '../../actions/purchase_orders';
import fetchBrands from '../../actions/fetch_brands';
import fetchCategories from '../../actions/fetch_categories';
import PurchaseOrdersTable from './_table';
import PurchaseOrdersForm from './_form';
import PurchaseOrdersSummary from './_summary';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount () {
    this.fetchBrands();
    this.fetchCategories();
    this.loadPurchaseOrders(this.props.location.query);
  }

  componentWillReceiveProps(nextProps) {
    const currentQuery = this.props.location.query;
    const nextQuery = nextProps.location.query;

    if (currentQuery.brand !== nextQuery.brand || currentQuery.category !== nextQuery.category) {
      this.loadPurchaseOrders(nextQuery);
    }
  }

  render () {
    return (
      <div className="purchase_orders_index">
        <div className="row">
          <PurchaseOrdersForm brands={this.props.brands}
                              categories={this.props.categories}
                              columns="6"
                              history={this.props.history}
                              query={this.props.location.query}
                              loadPurchaseOrders={this.loadPurchaseOrders.bind(this)} />

          <PurchaseOrdersSummary columns="6" />
        </div>

        <PurchaseOrdersTable purchaseOrders={this.props.purchaseOrders} />

        <button className="btn btn-default btn-lg"
                style={{ width: '100%' }}
                onClick={this.loadMorePurchaseOrders.bind(this, this.nextPage())}>
          Load More Orders
        </button>
      </div>
    );
  }

  nextPage () {
    return this.props.page + 1;
  }

  fetchBrands (page) {
    this.props.dispatch(fetchBrands());
  }

  fetchCategories (page) {
    this.props.dispatch(fetchCategories());
  }

  loadPurchaseOrders (query) {
    this.props.dispatch(loadPurchaseOrders(query));
  }

  loadMorePurchaseOrders (page) {
    this.props.dispatch(loadMorePurchaseOrders(this.props.location.query, page));
  }
}

function applyState({ brands, categories, purchaseOrders }) {
  return { brands,
           categories,
           purchaseOrders: purchaseOrders.purchaseOrders };
}

export default connect(applyState)(PurchaseOrdersIndex);
