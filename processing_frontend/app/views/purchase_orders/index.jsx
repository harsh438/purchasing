import React from 'react';
import { connect } from 'react-redux';
import { loadBrands,
         loadCategories,
         loadGenders,
         loadOrderTypes,
         loadSeasons,
         loadSuppliers } from '../../actions/filters';

import { loadPurchaseOrders,
         loadMorePurchaseOrders,
         clearPurchaseOrders,
         cancelPurchaseOrders,
         updatePurchaseOrders } from '../../actions/purchase_orders';

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
    }

    if (this.props.purchaseOrders !== nextProps.purchaseOrders) {
      if (this.state && this.state.selected) {
        let newIds = map(nextProps.purchaseOrders, o => { return String(o.orderId) })
        this.setState({ selected: intersection(this.state.selected, newIds) })
      } else {
        this.setState({ selected: [] })
      }
    }
  }

  render () {
    return (
      <div className="purchase_orders_index">
        <PurchaseOrdersForm brands={this.props.brands}
                            categories={this.props.categories}
                            genders={this.props.genders}
                            history={this.props.history}
                            index={this}
                            loadPurchaseOrders={this.loadPurchaseOrders.bind(this)}
                            orderTypes={this.props.orderTypes}
                            seasons={this.props.seasons}
                            suppliers={this.props.suppliers}
                            query={this.props.location.query} />

        <PurchaseOrdersTable exportable={this.props.exportable}
                             index={this}
                             purchaseOrders={this.props.purchaseOrders}
                             summary={this.props.summary}
                             totalPages={this.props.totalPages}
                             totalCount={this.props.totalCount} />

        {this.renderLoadMoreButton()}
      </div>
    );
  }

  selectRow (id) {
    var selected = this.state.selected.slice();
    selected.push(id);
    this.setState({ selected: selected });
  }

  unSelectRow (id) {
    var selected = this.state.selected.slice();
    var index = selected.indexOf(id);

    while (index != -1) {
      selected.splice(index, 1);
      index = selected.indexOf(id);
    }

    this.setState({ selected: selected });
  }

  cancelSelected () {
    this.props.dispatch(cancelPurchaseOrders(this.state.selected));
  }

  setDeliveryDate (value) {
    this.setState({ deliveryDate: value });
  }

  changeDeliveryDateSelected () {
    this.props.dispatch(updatePurchaseOrders(this.state.selected, { delivery_date: this.state.deliveryDate }));
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

  loadPurchaseOrdersIfQuery () {
    let query = this.props.location.query;

    if (!this.isObjectEmpty(query)) {
      this.loadPurchaseOrders(query);
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
