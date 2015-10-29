import React from 'react';
import { connect } from 'react-redux';
import { loadBrands, loadCategories } from '../../actions/filters';
import { loadPurchaseOrders, loadMorePurchaseOrders } from '../../actions/purchase_orders';
import PurchaseOrdersTable from './_table';
import PurchaseOrdersForm from './_form';
import PurchaseOrdersSummary from './_summary';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount () {
    this.loadBrands();
    this.loadCategories();
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
                onClick={this.loadMorePurchaseOrders.bind(this)}>
          Load More Orders
        </button>
      </div>
    );
  }

  nextPage () {
    return this.props.page + 1;
  }

  loadBrands (page) {
    this.props.dispatch(loadBrands());
  }

  loadCategories (page) {
    this.props.dispatch(loadCategories());
  }

  loadPurchaseOrders (query) {
    this.props.dispatch(loadPurchaseOrders(query));
  }

  loadMorePurchaseOrders () {
    this.props.dispatch(loadMorePurchaseOrders(this.props.location.query, this.nextPage()));
  }
}

function applyState({ filters, purchaseOrders }) {
  return { brands: filters.brands,
           categories: filters.categories,
           page: purchaseOrders.page,
           purchaseOrders: purchaseOrders.purchaseOrders };
}

export default connect(applyState)(PurchaseOrdersIndex);
