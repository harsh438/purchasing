import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { map, assign } from 'lodash';
import Qs from 'qs';
import { loadOrder,
         createLineItemsForOrder,
         deleteLineItem,
         updateLineItem,
         exportOrder } from '../../actions/orders';
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
          <div className="row" style={{ marginBottom: '20px' }}>
            <div className="col-md-6">
              <h1>
                <Link to="/orders">Orders</Link>
                &nbsp;/ {this.props.order.name}
                {this.renderExportedBadge()}
              </h1>
            </div>
          </div>

          <div className="row">
            <div className="col-md-12">
              {this.renderAddLineItemsForm()}
            </div>
          </div>

          {this.renderOrderExportsTable()}

          <OrderLineItemsTable editable={!this.props.order.exported}
                               lineItems={this.props.order.lineItems || []}
                               errors={this.props.errors}
                               erroredFields={this.props.erroredFields}
                               erroredIds={this.props.erroredIds}
                               onOrderLineItemDelete={this.handleOrderLineItemDelete.bind(this)}
                               onOrderExport={this.handleOrderExport.bind(this)}
                               table={this} />
        </div>
      </div>
    );
  }

  renderAddLineItemsForm() {
    if (!this.props.order.exported) {
      return (
        <OrderLineItemsForm errors={this.props.errors}
                            erroredFields={this.props.erroredFields}
                            onAddLineItems={this.handleOrderLineItemsAdd.bind(this)} />
      );
    }
  }

  renderExportedBadge() {
    if (this.props.order.exported) {
      return (
        <small style={{ position: 'relative', top: '-6px', left: '20px' }}>
          <span className="label label-success">Exported</span>
        </small>
      );
    }
  }

  renderOrderExportsTable() {
    if (!this.props.order.exported) {
      return (<div />);
    }

    return (
      <div className="row">
        <div className="col-md-6">
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
                    <th className="text-right">Summary</th>
                    <th className="text-right">SKU Export</th>
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
    if (!this.props.order.purchaseOrders || this.props.order.purchaseOrders.length === 0) {
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
          <td className="text-right">
            {this.renderCsvExportLink(this.purchaseOrderSummaryExportUrl(po))}
          </td>
          <td className="text-right">
            {this.renderCsvExportLink(this.purchaseOrderSkuExportUrl(po))}
          </td>
        </tr>
      );
    });
  }

  renderCsvExportLink(url) {
    return (
      <a href={url}
         className="btn btn-default btn-sm"
         target="_blank">
        <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
        &nbsp;Export as CSV
      </a>
    );
  }

  purchaseOrderSummaryExportUrl(po) {
    return `/api/purchase_orders/${po.id}.csv`;
  }

  purchaseOrderSkuExportUrl(po) {
    return `/api/skus.csv?purchase_order_id=${po.id}`;
  }

  handleOrderLineItemsAdd(lineItems) {
    const data = { order: { lineItemsAttributes: lineItems } };
    this.props.dispatch(createLineItemsForOrder(this.props.params.id, data));
  }

  handleOrderLineItemDelete(lineItemId) {
    if (confirm('Are you sure you want to delete this line item?')) {
      this.props.dispatch(deleteLineItem(lineItemId));
    }
  }

  handleOrderExport() {
    this.props.dispatch(exportOrder([this.props.params.id]));
  }

  updateField(id, key, value) {
    this.props.dispatch(updateLineItem([id], { [key]: value }));
  }
}

function applyState({ order }) {
  return assign({}, order);
}

export default connect(applyState)(OrdersEdit);
