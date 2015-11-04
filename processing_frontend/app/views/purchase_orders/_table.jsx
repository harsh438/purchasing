import React from 'react';
import PurchaseOrderTableHeader from './_table_header';
import PurchaseOrderRow from './_table_row';
import { sum } from 'lodash';

export default class PurchaseOrdersTable extends React.Component {
  componentWillMount () {
    this.state = { sticky: false, selected: [] };
    this.onScroll();
    window.addEventListener('scroll', this.onScroll.bind(this));
  }

  shouldComponentUpdate (nextProps, nextState) {
    return this.props.purchaseOrders !== nextProps.purchaseOrders || this.state.sticky !== nextState.sticky;
  }

  componentWillReceiveProps(nextProps, nextState) {
    if (this.props.purchaseOrders !== nextProps.purchaseOrders) {
      this.setState({ selected: [] })
    }
  }

  componentWillUnmount () {
    window.removeEventListener('scroll', this.onScroll.bind(this));
  }

  render () {
    return (
      <div className={this.className()} style={{ paddingTop: this.paddingTop() }}>
        <table className="table" style={{ width: this.tableWidth() }}>
          <colgroup>{this.renderCols()}</colgroup>

          <PurchaseOrderTableHeader cellWidths={this.cellWidths()}
                                    exportable={this.props.exportable}
                                    ref={(header) => this.header = header}
                                    summary={this.props.summary}
                                    totalPages={this.props.totalPages}
                                    totalCount={this.props.totalCount}
                                    width={this.tableWidth()} />

          <tbody>{this.renderRows()}</tbody>
        </table>
        {this.renderEmpty()}
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

  cellWidths () {
    return [48, 48,
            54, 180, 90, 49, 57,
            70, 60, 35, 50, 60,
            70, 35, 35, 50, 50,
            35, 50, 50,
            35, 50, 50,
            50, 50];
  }

  tableWidth () {
    return `${sum(this.cellWidths())}px`;
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

    return this.props.purchaseOrders.map((purchaseOrder) => {
      if (currentPoNumber !== purchaseOrder.poNumber) {
        currentPoNumber = purchaseOrder.poNumber;
        alt = !alt;
      }

      return (
        <PurchaseOrderRow alt={alt}
                          table={this}
                          key={purchaseOrder.orderId}
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
      return window.pageYOffset > 360;
    }
  }
}
