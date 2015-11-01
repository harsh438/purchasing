import React from 'react';
import PurchaseOrderTableHeader from './_table_header';
import PurchaseOrderRow from './_table_row';

export default class PurchaseOrdersTable extends React.Component {
  componentWillMount () {
    this.state = { sticky: false };
    this.rows = [];
    this.onScroll();
    window.addEventListener('scroll', this.onScroll.bind(this));
  }

  componentDidMount () {
    this.fixWidths();
  }

  shouldComponentUpdate (nextProps, nextState) {
    return this.props.purchaseOrders !== nextProps.purchaseOrders || this.state.sticky !== nextState.sticky;
  }

  componentDidUpdate () {
    this.fixWidths();
  }

  componentWillUnmount () {
    window.removeEventListener('scroll', this.onScroll.bind(this));
  }

  render () {
    return (
      <div className={this.className()}>
        <table className="table" style={{ width: '1500px' }}>
          <PurchaseOrderTableHeader ref={(header) => this.header = header}
                                    width="1500px" />

          <tbody>{this.renderRows()}</tbody>
        </table>
      </div>
    );
  }

  renderRows () {
    let currentPoNumber;
    let alt = true;
    console.log('renderRows', this.props.purchaseOrders.length);

    return this.props.purchaseOrders.map((purchaseOrder) => {
      if (currentPoNumber !== purchaseOrder.poNumber) {
        currentPoNumber = purchaseOrder.poNumber;
        alt = !alt;
      }

      console.log('mapping')

      return (
        <PurchaseOrderRow alt={alt}
                          key={purchaseOrder.orderId}
                          ref={this.addRow.bind(this)}
                          purchaseOrder={purchaseOrder} />
      );
    });
  }

  className () {
    let className = 'purchase_orders_table';

    if (this.state.sticky) {
      className += '--sticky';
    }

    return className;
  }

  onScroll () {
    const shouldStick = window.pageYOffset > 290;

    if (!this.state.sticky && shouldStick) {
      this.setState({ sticky: true });
    } else if (this.state.sticky && !shouldStick) {
      this.setState({ sticky: false });
    }
  }

  addRow (row) {
    if (row === null) {
      this.rows = [];
    } else {
      this.rows.push(row);
    }
  }

  fixWidths () {
    console.log('fixWidths', this.rows.length);

    if (this.rows[0]) {
      const widths = this.rows[0].calculateCellWidths();
      this.header.fixCellWidths(widths);

      for (let i = 0; i < this.rows.length; i++) {
        this.rows[i].fixCellWidths(widths);
      }
    }
  }
}
