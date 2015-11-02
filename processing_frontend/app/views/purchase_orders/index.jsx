import React from 'react';
import { connect } from 'react-redux';
import { loadBrands, loadCategories, loadGenders } from '../../actions/filters';
import { loadPurchaseOrders, loadMorePurchaseOrders } from '../../actions/purchase_orders';
import PurchaseOrdersForm from './_form';
import PurchaseOrdersTable from './_table';
import deepEqual from 'deep-equal';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount () {
    this.loadBrands();
    this.loadGenders();
    this.loadCategories();
    this.loadPurchaseOrders(this.props.location.query);
  }

  componentWillReceiveProps(nextProps) {
    if (!deepEqual(this.props.location.query, nextProps.location.query)) {
      this.loadPurchaseOrders(nextProps.location.query);
    }
  }

  render () {
    return (
      <div className="purchase_orders_index">
        <PurchaseOrdersForm brands={this.props.brands}
                            genders={this.props.genders}
                            categories={this.props.categories}
                            history={this.props.history}
                            query={this.props.location.query}
                            loadPurchaseOrders={this.loadPurchaseOrders.bind(this)} />

        <PurchaseOrdersTable purchaseOrders={this.props.purchaseOrders} />

        {this.renderLoadMoreButton()}
      </div>
    );
  }

  renderLoadMoreButton () {
    if (this.props.moreResultsAvailable) {
      return (
        <button className="btn btn-default btn-lg"
                style={{ width: '100%' }}
                onClick={this.loadMorePurchaseOrders.bind(this)}>
          Load More Orders
        </button>
      );
    }
  }

  loadBrands (page) {
    this.props.dispatch(loadBrands());
  }

  loadGenders (page) {
    this.props.dispatch(loadGenders());
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

  nextPage () {
    return parseInt(this.props.page, 10) + 1;
  }
}

function applyState({ filters, purchaseOrders }) {
  return Object.assign({}, filters, purchaseOrders);
}

export default connect(applyState)(PurchaseOrdersIndex);
