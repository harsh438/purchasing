import React from 'react'
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { map, assign } from 'lodash';
import { loadOrder, createLineItemForOrder, deleteLineItem, updateLineItem } from '../../actions/orders'
import EditRowCost from '../edit_row/_cost'
import EditRowDiscount from '../edit_row/_discount'
import EditRowQuantity from '../edit_row/_quantity'
import { WeekSelect, dropDates } from './_week_select'

class OrdersEdit extends React.Component {
  componentWillMount() {
    this.resetState();

    if (this.props.params.id != this.props.order.id) {
      this.props.dispatch(loadOrder(this.props.params.id));
    }
  }

  componentWillReceiveProps(nextProps) {
    if (this.props != nextProps) {
      this.resetState();
    }
  }

  render() {
    return (
      <div className="order_edit" style={{ marginTop: '70px' }}>
        <div className="container-fluid">
          {this.renderBackLink()}

          {this.renderOrderRow()}

          {this.renderPurchaseOrderRow()}

          {this.renderOrderLineForm()}

          {this.renderOrderLineRow()}
        </div>
      </div>
    );
  }

  renderOrderLineRow() {
    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">Order line items</div>
            <div className="panel-body">
              <table className="table">
                <thead>
                  <tr>
                    <th>Brand Name</th>
                    <th>Product Name</th>
                    <th>Internal SKU</th>
                    <th>Quantity</th>
                    <th>Cost</th>
                    <th>Discount %</th>
                    <th>Drop Date</th>
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

  renderOrderLineForm() {
    if (this.props.order.exported) {
      return (<div />);
    }

    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">Create line item</div>
            <div className="panel-body">
              <form className="form" onSubmit={this.handleLineItemSubmit.bind(this)}>
                <div className="form-group col-md-2">
                  <label htmlFor="internalSku">Internal SKU</label>
                  <input type="text"
                         name="internalSku"
                         onChange={this.handleChange.bind(this, 'internalSku')}
                         className="form-control"
                         required="required"
                         value={this.state.internalSku} />
                </div>
                <div className="form-group col-md-2">
                  <label htmlFor="quantity">Quantity</label>
                  <input type="number"
                         name="quantity"
                         onChange={this.handleChange.bind(this, 'quantity')}
                         className="form-control"
                         required="required"
                         value={this.state.quantity} />
                </div>
                <div className="form-group col-md-2">
                  <label htmlFor="discount">Discount %</label>
                  <input type="number"
                         step="0.01"
                         name="discount"
                         onChange={this.handleChange.bind(this, 'discount')}
                         className="form-control"
                         required="required"
                         value={this.state.discount} />
                </div>
                <WeekSelect table={this} />
                <div className="form-group col-md-2" style={{ marginTop: '1.7em' }}>
                  <button className="btn btn-success">
                    Create
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderLineItems() {
    if (!this.props.order.lineItems || this.props.order.lineItems.length == 0) {
      return (<tr><td><h4>No line items found.</h4></td></tr>);
    }

    return map(this.props.order.lineItems, (line) => {
      return (
        <tr>
          <td>{line.vendorName}</td>
          <td>{line.productName}</td>
          <td>{line.internalSku}</td>

          {this.renderEditQuantityRow(line)}
          {this.renderEditCostRow(line)}
          {this.renderEditDiscountRow(line)}

          <td>{line.dropDate}</td>
          <td>{this.renderDeleteForm(line)}</td>
        </tr>
      );
    })
  }

  renderEditCostRow(line) {
    if (this.props.order.exported) {
      return (<td>{line.cost}</td>);
    }

    return (
      <EditRowCost displayValue={line.cost}
                   ident={line.id}
                   table={this}
                   value={line.cost.replace(/[^\d.-]/g, '')} />
    );
  }

  renderEditQuantityRow(line) {
    if (this.props.order.exported) {
      return (<td>{line.quantity}</td>);
    }

    return (
      <EditRowQuantity displayValue={line.quantity}
                       ident={line.id}
                       table={this}
                       value={line.quantity} />
    );
  }

  renderEditDiscountRow(line) {
    if (this.props.order.exported) {
      return (<td>{line.discount}</td>);
    }

    return (
      <EditRowDiscount displayValue={line.discount}
                       ident={line.id}
                       table={this}
                       value={line.discount} />
    );
  }

  renderDeleteForm(line) {
    if (this.props.order.exported) {
      return (<span />);
    }

    return (
      <form className="form" onSubmit={this.handleLineItemDelete.bind(this, line.id)}>
        <button className="btn btn-danger">
          Delete
        </button>
      </form>
    );
  }

  renderBackLink() {
    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-body">
              <Link to="/orders">Temporary link back to orders</Link>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderOrderRow() {
    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">Order detail</div>
            <div className="panel-body">
              <table className="table">
                <thead>
                  <tr>
                    <th>Id</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th>Updated</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{this.props.order.id}</td>
                    <td>{this.props.order.status}</td>
                    <td>{this.props.order.createdAt}</td>
                    <td>{this.props.order.updatedAt}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderPurchaseOrderRow() {
    if (!this.props.order.exported) {
      return (<div />);
    }

    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">Purchase Orders</div>
            <div className="panel-body">
              <table className="table">
                <thead>
                  <tr>
                    <th>PO #</th>
                    <th>Vendor</th>
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
        <tr>
          <td>
            <Link to={`/?poNumber=${po.id}`}>
              {po.id}
            </Link>
          </td>
          <td>{po.vendorName}</td>
        </tr>
      );
    })
  }

  handleLineItemSubmit (e) {
    e.preventDefault();
    this.props.dispatch(createLineItemForOrder(this.props.params.id, this.lineItemState()))
  }

  lineItemState() {
    return { order: { lineItemsAttributes: [{ internalSku: this.state.internalSku,
                                              quantity: this.state.quantity,
                                              cost: this.state.cost,
                                              discount: this.state.discount,
                                              dropDate: this.state.dropDate }] } }
  }

  updateField(id, key, value) {
    this.props.dispatch(updateLineItem([id], { [key]: value }));
  }

  handleLineItemDelete (lineItemId) {
    if (confirm('Are you sure you want to delete this line item?')) {
      this.props.dispatch(deleteLineItem(lineItemId));
    }
  }

  handleChange (field, { target }) {
    this.setState({ [field]: target.value });
  }

  resetState() {
    this.setState({ internalSku: '',
                    quantity: 0,
                    productCost: '0.00',
                    discount: '0.00',
                    dropDate: dropDates()[0].value});
  }
}

function applyState({ order }) {
  return assign({}, order);
}

export default connect(applyState)(OrdersEdit);
