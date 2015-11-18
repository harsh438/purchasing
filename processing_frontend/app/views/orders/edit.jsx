import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { map, assign } from 'lodash';
import { loadOrder, createLineItemsForOrder, deleteLineItem, updateLineItem } from '../../actions/orders';
import OrderLineItemsTable from '../order_line_items/_table';
import OrderLineItemsForm from '../order_line_items/_form';

class OrdersEdit extends React.Component {
  componentWillMount() {
    this.props.dispatch(loadOrder(this.props.params.id));
  }

  render() {
    return (
      <div className="order_edit" style={{ marginTop: '70px' }}>
        <div className="container-fluid">
          <div className="row">
            <div className="col-md-12">
              <div className="panel panel-default">
                <div className="panel-heading">
                  <h3 className="panel-title">{this.props.order.name}</h3>
                </div>

                <div className="panel-body">
                  {this.renderAddLineItemsForm()}
                </div>
              </div>
            </div>
          </div>

          {this.renderOrderExportsTable()}

          <OrderLineItemsTable editable={this.props.order.exported}
                               lineItems={this.props.order.lineItems || []}
                               errors={this.props.errors}
                               erroredFields={this.props.erroredFields}
                               erroredIds={this.props.erroredIds}
                               onOrderLineItemDelete={this.handleOrderLineItemDelete.bind(this)}
                               table={this} />
        </div>
      </div>
    );
  }

  renderAddLineItemsForm() {
    if (this.props.order.exported) {
      return (<span className="label label-success">Exported</span>);
    } else {
      return (
        <OrderLineItemsForm errors={this.props.errors}
                            onAddLineItems={this.handleAddLineItems.bind(this)} />
      );
    }
  }

  renderOrderExportsTable() {
    if (!this.props.order.exported) {
      return (<div />);
    }

    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">Generated Purchase Orders</h3>
            </div>

            <div className="panel-body">
              <table className="table">
                <thead>
                  <tr>
                    <th>PO #</th>
                    <th>Vendor</th>
                    <th>Download</th>
                  </tr>
                </thead>
                <tbody>
                  {this.renderPurchaseOrders()}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderPurchaseOrders() {
    if (!this.props.order.purchaseOrders || this.props.order.purchaseOrders.length == 0) {
      return (<tr><td><h4>No purchase orders found.</h4></td></tr>);
    }

    return map(this.props.order.purchaseOrders, (po) => {
      return (
        <tr key={po.id}>
          <td>
            <Link to={`/?poNumber=${po.id}`}>
              {po.id}
            </Link>
          </td>
          <td>{po.vendorName}</td>
          <td>
            <a href={`/api/purchase_order_line_items.csv?po_number=${po.id}&summary_id=${po.id}`}
               className="btn btn-default btn-sm"
               target="_blank">
              export as .csv
            </a>
          </td>
        </tr>
      );
    })
  }

  handleAddLineItems(lineItems) {
    const data = { order: { lineItemsAttributes: lineItems } };
    this.props.dispatch(createLineItemsForOrder(this.props.params.id, data));
  }

  updateField(id, key, value) {
    this.props.dispatch(updateLineItem([id], { [key]: value }));
  }

  handleOrderLineItemDelete(lineItemId) {
    if (confirm('Are you sure you want to delete this line item?')) {
      this.props.dispatch(deleteLineItem(lineItemId));
    }
  }
}

function applyState({ order }) {
  return assign({}, order);
}

export default connect(applyState)(OrdersEdit);
