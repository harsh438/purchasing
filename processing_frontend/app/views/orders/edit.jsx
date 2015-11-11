import React from 'react'
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { map, assign } from 'lodash';
import { loadOrder, createLineItemForOrder } from '../../actions/orders'

class OrdersEdit extends React.Component {
  componentWillMount() {
    if (this.props.params.id != this.props.order.id) {
      this.props.dispatch(loadOrder(this.props.params.id));
    }
  }

  render() {
    return (
      <div className="order_edit"
           style={{ marginTop: '70px' }}>
        <div className="container-fluid">
          <div className="row">
            <div className="panel panel-default">
              <div className="panel-body">
                <Link to="/orders">Temporary link back to orders</Link>
              </div>
            </div>

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

          <div className="row">
            <div className="col-md-3">
              <button className="btn btn-success"
                      style={{ marginTop: '1.74em', width: '100%' }}
                      onClick={this.dispatchCreateLineItem.bind(this)}>
                New Line Item
              </button>
            </div>
          </div>

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
        </div>
      </div>
    );
  }

  dispatchCreateLineItem() {
    this.props.dispatch(createLineItemForOrder(this.props.params.id,
                                               { order: { lineItemsAttributes: [{ internalSku: '1123-123',
                                                                                  quantity: 5,
                                                                                  cost: '1.40',
                                                                                  discount: 3,
                                                                                  dropDate: '2012-01-01' }] } }))
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
}

function applyState({ order }) {
  return assign({}, order);
}

export default connect(applyState)(OrdersEdit);
