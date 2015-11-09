import React from 'react';
import PurchaseOrdersTableActions from './_table_actions';
import PurchaseOrderTableHeader from './_table_header';
import PurchaseOrderRow from './_table_row';

import { cancelPurchaseOrders,
         uncancelPurchaseOrders,
         updatePurchaseOrders } from '../../actions/purchase_orders';

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
        <PurchaseOrdersTableActions table={this}
                                    exportable={this.props.exportable}
                                    hasSelected={this.state.selected.length > 0}
                                    currentCount={this.props.purchaseOrders.length}
                                    totalCount={this.props.totalCount} />

        <table className="table" style={{ width: this.tableWidth() }}>
          <colgroup>{this.renderCols()}</colgroup>

          <PurchaseOrderTableHeader cellWidths={this.cellWidths()}
                                    ref={(header) => this.header = header}
                                    summary={this.props.summary}
                                    totalPages={this.props.totalPages}
                                    width={this.tableWidth()}
                                    onSelectAll={this.handleSelectAll.bind(this)} />
          <tbody>{this.renderRows()}</tbody>
        </table>
        {this.renderEmpty()}
      </div>
    );
  }

  cellWidths () {
    return [30, 48,
            54, 180, 90, 49, 57, 57, 50, 50,
            60, 35, 50, 60,
            70, 35, 35, 50, 50,
            35, 50, 50,
            35, 50, 50];
  }

  renderCols () {
    const cellWidths = this.cellWidths();
    let cols = [];

    for (let i = 0; i < cellWidths.length; i++) {
      cols.push((
        <col key={i} style={{ width: cellWidths[i] }} />
      ));
    }

    return cols;
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
                          table={this}
                          checked={contains(this.state.selected, purchaseOrder.orderId)}
                          key={purchaseOrder.orderId}
                          onChange={this.handleRowChange.bind(this)}
                          purchaseOrder={purchaseOrder} />
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
    this.props.dispatch(cancelPurchaseOrders(this.state.selected));
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
    this.props.dispatch(updatePurchaseOrders(this.state.selected, { delivery_date: this.state.deliveryDate }));
  }
}
