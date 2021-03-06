import React from 'react';
import { connect } from 'react-redux';
import { loadVendors,
         loadSuppliers,
         loadGenders,
         loadOrderTypes,
         loadCategories,
         loadSeasons } from '../../actions/filters';
import { clearPurchaseOrders,
         loadMorePurchaseOrders,
         loadPurchaseOrders,
         loadSummary } from '../../actions/purchase_orders';
import Filters from './_filters';
import PurchaseOrdersTableActions from './_table';
import { assign, intersection, isEqual, map } from 'lodash';
import { isEmptyObject } from '../../utilities/inspection';

class PurchaseOrderLineItemsIndex extends React.Component {
  componentWillMount() {
    this.props.dispatch(loadVendors({ relevant: true }));
    this.props.dispatch(loadSuppliers({ relevant: true }));
    this.props.dispatch(loadGenders());
    this.props.dispatch(loadOrderTypes());
    this.props.dispatch(loadCategories());
    this.props.dispatch(loadSeasons());
    this.loadPurchaseOrdersIfQuery();
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (isEmptyObject(nextQuery)) {
      this.clearPurchaseOrders();
    } else if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPurchaseOrders(nextQuery);
      this.loadSummary(nextQuery);
    }
  }

  render() {
    return (
      <div className="purchase_orders_index">
        <div className="container-fluid"
             style={{ marginTop: '70px' }}>
          <div className="row" style={{ marginBottom: '20px' }}>
            <div className="col-md-12">
              <h1>Purchase order lines</h1>
            </div>
          </div>
        </div>

        <Filters brands={this.props.brands}
                 categories={this.props.categories}
                 genders={this.props.genders}
                 history={this.props.history}
                 loading={this.props.loading}
                 loadPurchaseOrders={this.loadPurchaseOrders.bind(this)}
                 orderTypes={this.props.orderTypes}
                 seasons={this.props.seasons}
                 suppliers={this.props.suppliers}
                 query={this.props.location.query} />

        <PurchaseOrdersTableActions dispatch={this.props.dispatch}
               exportable={this.props.exportable}
               purchaseOrders={this.props.purchaseOrders}
               summary={this.props.summary}
               totalPages={this.props.totalPages}
               totalCount={this.props.totalCount}
               query={this.props.location.query} />

        {this.renderLoadMoreButton()}
      </div>
    );
  }

  renderLoadMoreButton() {
    if (this.props.moreResultsAvailable) {
      if (this.props.loading) {
        return (
          <button className="btn btn-default btn-lg"
                  style={{ width: '100%' }}
                  disabled="disabled">
            Loading...
          </button>
        );
      } else {
        return (
          <button className="btn btn-default btn-lg"
                  style={{ width: '100%' }}
                  onClick={this.loadMorePurchaseOrders.bind(this)}>
            Load More Orders
          </button>
        );
      }
    }
  }

  loadPurchaseOrders(query) {
    this.props.dispatch(loadPurchaseOrders(query));
  }

  loadSummary(query) {
    this.props.dispatch(loadSummary(query));
  }

  loadPurchaseOrdersIfQuery() {
    let query = this.props.location.query;

    if (!isEmptyObject(query)) {
      this.loadPurchaseOrders(query);
      this.loadSummary(query);
    }
  }

  clearPurchaseOrders() {
    this.props.dispatch(clearPurchaseOrders());
  }

  loadMorePurchaseOrders() {
    this.props.dispatch(loadMorePurchaseOrders(this.props.location.query, this.nextPage()));
  }

  nextPage() {
    return parseInt(this.props.page, 10) + 1;
  }
}

function applyState({ filters, purchaseOrders }) {
  return assign({}, filters, purchaseOrders);
}

export default connect(applyState)(PurchaseOrderLineItemsIndex);
