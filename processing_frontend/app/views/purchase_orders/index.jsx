import React from 'react';
import { connect } from 'react-redux';
import { loadBrands,
         loadCategories,
         loadGenders,
         loadOrderTypes,
         loadSeasons,
         loadSuppliers } from '../../actions/filters';
import { loadPurchaseOrders, loadMorePurchaseOrders } from '../../actions/purchase_orders';
import PurchaseOrdersForm from './_form';
import PurchaseOrdersTable from './_table';
import deepEqual from 'deep-equal';

class PurchaseOrdersIndex extends React.Component {
  componentWillMount () {
    this.loadBrands();
    this.loadCategories();
    this.loadGenders();
    this.loadOrderTypes();
    this.loadPurchaseOrders(this.props.location.query);
    this.loadSeasons();
    this.loadSuppliers();
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
                            categories={this.props.categories}
                            genders={this.props.genders}
                            history={this.props.history}
                            loadPurchaseOrders={this.loadPurchaseOrders.bind(this)}
                            orderTypes={this.props.orderTypes}
                            seasons={this.props.seasons}
                            suppliers={this.props.suppliers}
                            query={this.props.location.query} />

        <PurchaseOrdersTable exportable={this.props.exportable}
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

  loadBrands () {
    this.props.dispatch(loadBrands());
  }

  loadSuppliers () {
    this.props.dispatch(loadSuppliers());
  }

  loadGenders () {
    this.props.dispatch(loadGenders());
  }

  loadOrderTypes () {
    this.props.dispatch(loadOrderTypes());
  }

  loadCategories () {
    this.props.dispatch(loadCategories());
  }

  loadSeasons () {
    this.props.dispatch(loadSeasons());
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
