import React from 'react';
import PurchaseOrdersTableActions from './_table_actions';
import PurchaseOrderTableHeader from './_table_header';
import PurchaseOrderRow from './_table_row';

import { cancelPurchaseOrders,
         uncancelPurchaseOrders,
         updatePurchaseOrders,
         cancelEntirePurchaseOrder } from '../../actions/purchase_orders';

import { sum, map, intersection, pluck, contains } from 'lodash';

export default class PurchaseOrdersTable extends React.Component {
  componentWillMount () {
    this.state = { sticky: false, selected: [] };
    this.onScroll();
    window.addEventListener('scroll', this.onScroll.bind(this));
  }

  shouldComponentUpdate (nextProps, nextState) {
    return this.props.purchaseOrders !== nextProps.purchaseOrders ||
           this.state.sticky !== nextState.sticky ||
           this.props.summary !== nextProps.summary ||
           this.state.selected !== nextState.selected;
  }

  componentWillReceiveProps (nextProps) {
    if (this.props.purchaseOrders !== nextProps.purchaseOrders) {
      const newIds = map(nextProps.purchaseOrders, o => o.orderId)
      this.setState({ selected: intersection(this.state.selected, newIds) })
    }
  }

  componentWillUnmount () {
    window.removeEventListener('scroll', this.onScroll.bind(this));
  }

  render () {
    return (
      <div className={this.className()} style={{ paddingTop: this.paddingTop() }}>
        <PurchaseOrdersTableActions currentCount={this.props.purchaseOrders.length}
                                    exportable={this.props.exportable}
                                    hasSelected={this.state.selected.length > 0}
                                    poNumber={this.props.query.poNumber}
                                    table={this}
                                    totalCount={this.props.totalCount} />

        <table className="table">
          <colgroup></colgroup>

          <PurchaseOrderTableHeader ref={(header) => this.header = header}
                                    summary={this.props.summary}
                                    totalPages={this.props.totalPages}
                                    onSelectAll={this.handleSelectAll.bind(this)} />
          <tbody>{this.renderRows()}</tbody>
        </table>
        {this.renderEmpty()}
      </div>
    );
  }

  renderRows () {
    let currentPoNumber;
    let alt = true;

    return map(this.props.purchaseOrders, (purchaseOrder) => {
      if (currentPoNumber !== purchaseOrder.poNumber) {
        currentPoNumber = purchaseOrder.poNumber;
        alt = !alt;
      }

      return (
        <PurchaseOrderRow alt={alt}
                          checked={contains(this.state.selected, purchaseOrder.orderId)}
                          key={purchaseOrder.orderId}
                          onChange={this.handleRowChange.bind(this)}
                          purchaseOrder={purchaseOrder}
                          table={this} />
      );
    });
  }

  renderEmpty () {
    if (this.props.purchaseOrders.length == 0) {
      return(
        <div style={{ width: '100%', textAlign: 'center' }}>
          No results to show.
        </div>
      );
    }
  }

  tableWidth () {
    return `${sum(this.cellWidths())}px`;
  }

  className () {
    let className = 'purchase_orders_table';
    if (this.state.sticky) className += '--sticky';
    return className;
  }

  paddingTop () {
    if (this.header && this.shouldStick()) {
      return this.header.refs.thead.clientHeight;
    }
  }

  onScroll () {
    const shouldStick = this.shouldStick();

    if (!this.state.sticky && shouldStick) {
      this.setState({ sticky: true });
    } else if (this.state.sticky && !shouldStick) {
      this.setState({ sticky: false });
    }
  }

  shouldStick () {
    if (this.header) {
      return window.pageYOffset > 444;
    }
  }

  handleRowChange ({ target }) {
    if (target.checked) {
      this.selectRow(parseInt(target.value, 10));
    } else {
      this.unSelectRow(parseInt(target.value, 10));
    }
  }

  handleSelectAll ({ target }) {
    let orderIds = [];

    if (target.checked) {
      orderIds = pluck(this.props.purchaseOrders, 'orderId');
    }

    this.setState({ selected: orderIds });
  }

  selectRow (id) {
    var selected = this.state.selected.slice();
    if (!contains(selected, id)) {
      selected.push(id);
    }
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
    if (confirm(`Cancelling all selected items, are you sure?`)) {
      this.props.dispatch(cancelPurchaseOrders(this.state.selected));
    }
  }

  cancelPO () {
    if (!this.props.query.poNumber) {
      return;
    }
    if (confirm(`Cancelling PO# ${this.props.query.poNumber}, are you sure?`)) {
      this.props.dispatch(cancelEntirePurchaseOrder(this.props.query.poNumber));
    }
  }

  uncancelSelected () {
    this.props.dispatch(uncancelPurchaseOrders(this.state.selected));
  }

  updateField(id, key, value) {
    this.props.dispatch(updatePurchaseOrders([id], { [key]: value }));
  }

  setDeliveryDate (value) {
    this.setState({ deliveryDate: value });
  }

  changeDeliveryDateSelected () {
    if (!this.state.deliveryDate) {
      return;
    }

    this.props.dispatch(updatePurchaseOrders(this.state.selected, { delivery_date: this.state.deliveryDate }));
  }
}
