import React from 'react';
import PurchaseOrderTableHeader from './_table_header';
import PurchaseOrderRow from './_table_row';

export default class PurchaseOrdersTable extends React.Component {
  componentWillMount () {
    this.state = { sticky: false };
    this.onScroll();
    window.addEventListener('scroll', this.onScroll.bind(this));
  }

  shouldComponentUpdate (nextProps, nextState) {
    return this.props.purchaseOrders !== nextProps.purchaseOrders || this.state.sticky !== nextState.sticky;
  }

  componentWillUnmount () {
    window.removeEventListener('scroll', this.onScroll.bind(this));
  }

  render () {
    return (
      <div className={this.className()} style={{ paddingTop: this.paddingTop() }}>
        <table className="table" style={{ width: '1600px' }}>
          <colgroup>{this.renderCols()}</colgroup>

          <PurchaseOrderTableHeader cellWidths={this.cellWidths()}
                                    exportable={this.props.exportable}
                                    ref={(header) => this.header = header}
                                    summary={this.props.summary}
                                    totalPages={this.props.totalPages}
                                    totalCount={this.props.totalCount}
                                    width="1600px" />

          <tbody>{this.renderRows()}</tbody>
        </table>
      </div>
    );
  }

  cellWidths () {
    return [48, 64, 54, 271, 40, 49, 57, 60, 52, 42, 35, 42, 33, 50, 35, 42, 33, 35, 42, 33, 35, 42, 33, 74, 52, 57, 65, 56, 69];
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
                          key={purchaseOrder.orderId}
                          purchaseOrder={purchaseOrder} />
      );
    });
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
