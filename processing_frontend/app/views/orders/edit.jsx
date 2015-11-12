import React from 'react'
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { map, assign } from 'lodash';
import { loadOrder, createLineItemForOrder } from '../../actions/orders'

class OrdersEdit extends React.Component {
  componentWillMount() {
    this.state = { internalSku: '',
                   quantity: 0,
                   cost: '0.00',
                   discount: '0.00',
                   dropDate: '' };

    if (this.props.params.id != this.props.order.id) {
      this.props.dispatch(loadOrder(this.props.params.id));
    }
  }

  render() {
    return (
      <div className="order_edit" style={{ marginTop: '70px' }}>
        <div className="container-fluid">
          {this.renderBackLink()}

          {this.renderOrderRow()}

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
          <table className="table">
            <thead>
              <tr>
                <th>Internal SKU</th>
                <th>Quantity</th>
                <th>Cost</th>
                <th>Discount</th>
              </tr>
            </thead>
            <tbody>
              {this.renderLineItems()}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  renderOrderLineForm() {
    return (
      <div className="row">
        <div className="col-md-12">
          <form className="form-inline" onSubmit={this.handleLineItemSubmit.bind(this)}>
            <div className="form-group">
              <label htmlFor="internalSku">Internal Sku</label>
              <input type="text"
                     name="internalSku"
                     onChange={this.handleChange.bind(this, 'internalSku')}
                     className="form-control"
                     value={this.state.internalSku} />
            </div>
            <div className="form-group">
              <label htmlFor="quantity">Quantity</label>
              <input type="number"
                     name="quantity"
                     onChange={this.handleChange.bind(this, 'quantity')}
                     className="form-control"
                     value={this.state.quantity} />
            </div>
            <div className="form-group">
              <label htmlFor="cost">Cost</label>
              <input type="number"
                     step="0.01"
                     name="cost"
                     onChange={this.handleChange.bind(this, 'cost')}
                     className="form-control"
                     value={this.state.cost} />
            </div>
            <div className="form-group">
              <label htmlFor="discount">Discount</label>
              <input type="number"
                     step="0.01"
                     name="discount"
                     onChange={this.handleChange.bind(this, 'discount')}
                     className="form-control"
                     value={this.state.discount} />
            </div>
            <div className="form-group">
              <label htmlFor="dropDate">Drop Date</label>
              <input type="date"
                     name="dropDate"
                     onChange={this.handleChange.bind(this, 'dropDate')}
                     className="form-control"
                     value={this.state.dropDate} />
            </div>
            <div className="form-group">
              <button className="btn btn-success">
                Create
              </button>
            </div>
          </form>
        </div>
      </div>
    );
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

  handleChange (field, { target }) {
    this.setState({ [field]: target.value });
  }

  renderLineItems() {
    return map(this.props.order.lineItems, (line) => {
      return (
        <tr>
          <td>{line.internalSku}</td>
          <td>{line.quantity}</td>
          <td>{line.cost}</td>
          <td>{line.discount}</td>
        </tr>
      );
    })
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
    );
  }
}

function applyState({ order }) {
  return assign({}, order);
}

export default connect(applyState)(OrdersEdit);
