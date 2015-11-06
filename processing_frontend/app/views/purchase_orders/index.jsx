import React from 'react';
import { connect } from 'react-redux';
import { loadBrands,
         loadCategories,
         loadGenders,
         loadOrderTypes,
         loadSeasons,
         loadSuppliers } from '../../actions/filters';

import { loadSummary,
         loadPurchaseOrders,
         loadMorePurchaseOrders,
         clearPurchaseOrders } from '../../actions/purchase_orders';

import PurchaseOrdersForm from './_form';
import PurchaseOrdersTable from './_table';

import deepEqual from 'deep-equal';
import { isEmpty, assign, map, intersection } from 'lodash';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadBrands());
    this.props.dispatch(loadSuppliers());
    this.props.dispatch(loadGenders());
    this.props.dispatch(loadOrderTypes());
    this.props.dispatch(loadCategories());
    this.props.dispatch(loadSeasons());
    this.loadPurchaseOrdersIfQuery();
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (this.isObjectEmpty(nextQuery)) {
      this.clearPurchaseOrders();
    } else if (!deepEqual(this.props.location.query, nextQuery)) {
      this.loadPurchaseOrders(nextQuery);
      this.loadSummary(nextQuery);
    }

  }

  render () {
    return (
      <div className="purchase_orders_index">
        <PurchaseOrdersForm brands={this.props.brands}
                            categories={this.props.categories}
                            genders={this.props.genders}
                            history={this.props.history}
                            loadPurchaseOrders={this.loadPurchaseOrders.bind(this)}
                            orderTypes={this.props.orderTypes}
                            seasons={this.props.seasons}
                            suppliers={this.props.suppliers}
                            query={this.props.location.query} />

        <PurchaseOrdersTable dispatch={this.props.dispatch}
                             exportable={this.props.exportable}
                             purchaseOrders={this.props.purchaseOrders}
                             summary={this.props.summary}
                             totalPages={this.props.totalPages}
                             totalCount={this.props.totalCount} />

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

  loadPurchaseOrders (query) {
    this.props.dispatch(loadPurchaseOrders(query));
  }

  loadSummary (query) {
    this.props.dispatch(loadSummary(query));
  }

  loadPurchaseOrdersIfQuery () {
    let query = this.props.location.query;

    if (!this.isObjectEmpty(query)) {
      this.loadPurchaseOrders(query);
      this.loadSummary(query);
    }
  }

  clearPurchaseOrders () {
    this.props.dispatch(clearPurchaseOrders());
  }

  loadMorePurchaseOrders () {
    this.props.dispatch(loadMorePurchaseOrders(this.props.location.query, this.nextPage()));
  }

  nextPage () {
    return parseInt(this.props.page, 10) + 1;
  }

  isObjectEmpty (obj) {
    for (let prop in obj) {
      if (!isEmpty(obj[prop])) {
        return false;
      }
    }

    return true;
  }
}

function applyState({ filters, purchaseOrders }) {
  return assign({}, filters, purchaseOrders);
}

export default connect(applyState)(PurchaseOrdersIndex);
