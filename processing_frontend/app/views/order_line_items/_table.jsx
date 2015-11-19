import React from 'react';
import { map, partial } from 'lodash';
import EditRowCost from '../edit_row/_cost';
import EditRowDiscount from '../edit_row/_discount';
import EditRowQuantity from '../edit_row/_quantity';
import EditRowDate from '../edit_row/_date';

export default class OrderLineItemsTable extends React.Component {
  componentWillMount() {
    this.state = { exportingOrder: false };
  }

  render() {
    if (this.props.lineItems.length === 0) {
      return (
        <div style={{ width: '100%', textAlign: 'center' }}>
          No results to show.
        </div>
      );
    }

    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-body">
              <button className="btn btn-warning"
                      disabled={this.isExportButtonDisabled()}
                      onClick={this.handleExportOrder.bind(this)}>
                Generate Purchase Orders
              </button>

              <hr />

              <table className="table">
                <thead>
                  <tr>
                    <th style={{ width: '10%' }}>Brand Name</th>
                    <th style={{ width: '30%' }}>Product Name</th>
                    <th style={{ width: '10%' }}>Internal SKU</th>
                    <th className="text-center" style={{ width: '8%' }}>Quantity</th>
                    <th className="text-center" style={{ width: '8%' }}>Cost</th>
                    <th className="text-center" style={{ width: '8%' }}>Discount %</th>
                    <th className="text-center" style={{ width: '12%' }}>Drop Date</th>
                    <th style={{ width: '10%' }}>&nbsp;</th>
                  </tr>
                </thead>
                <tbody>
                  {this.renderLineItems()}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderLineItems() {
    return map(this.props.lineItems, (line) => {
      return (
        <tr key={line.id}>
          <td>{line.vendorName}</td>
          <td>{line.productName}</td>
          <td>{line.internalSku}</td>
          <td className="text-center">{this.renderEditQuantityRow(line)}</td>
          <td className="text-center">{this.renderEditCostRow(line)}</td>
          <td className="text-center">{this.renderEditDiscountRow(line)}</td>
          <td className="text-center">{this.renderEditDropDateRow(line)}</td>
          <td>{this.renderDeleteButton(line)}</td>
        </tr>
      );
    })
  }
  renderEditCostRow(line) {
    if (!this.props.editable) return line.cost;

    return (
      <EditRowCost displayValue={line.cost}
                   ident={line.id}
                   table={this.props.table}
                   value={line.cost.replace(/[^\d.-]/g, '')}
                   errors={this.props.errors}
                   erroredIds={this.props.erroredIds}
                   erroredFields={this.props.erroredFields} />
    );
  }

  renderEditQuantityRow(line) {
    if (!this.props.editable) return line.quantity;

    return (
      <EditRowQuantity displayValue={line.quantity}
                       ident={line.id}
                       table={this.props.table}
                       value={line.quantity}
                       errors={this.props.errors}
                       erroredIds={this.props.erroredIds}
                       erroredFields={this.props.erroredFields} />
    );
  }

  renderEditDiscountRow(line) {
    if (!this.props.editable) return line.discount;

    return (
      <EditRowDiscount displayValue={line.discount}
                       ident={line.id}
                       table={this.props.table}
                       value={line.discount}
                       errors={this.props.errors}
                       erroredIds={this.props.erroredIds}
                       erroredFields={this.props.erroredFields} />
    );
  }

  renderEditDropDateRow(line) {
    if (!this.props.editable) return line.displayDropDate;

    return (
      <EditRowDate displayValue={line.displayDropDate}
                   ident={line.id}
                   table={this.props.table}
                   value={line.dropDate}
                   errors={this.props.errors}
                   erroredIds={this.props.erroredIds}
                   erroredFields={this.props.erroredFields} />
    );
  }

  renderDeleteButton(line) {
    if (!this.props.editable) return (<span />);

    return (
      <button className="btn btn-danger"
              onClick={partial(this.props.onOrderLineItemDelete, line.id)}>
        Delete
      </button>
    );
  }

  isExportButtonDisabled() {
    return !this.props.editable || this.state.exportingOrder || this.props.lineItems.length === 0;
  }

  handleExportOrder() {
    this.setState({ exportingOrder: true });
    this.props.onOrderExport();
  }
}
