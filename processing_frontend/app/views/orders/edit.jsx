import React from 'react'
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import { loadOrder } from '../../actions/orders'

class OrdersEdit extends React.Component {
  componentWillMount() {
    this.props.dispatch(loadOrder(this.props.params.id));
  }

  render() {
    return (
      <div className="order_edit">
        <div className="container-fluid">
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
  console.log(order);
  return assign({}, order);
}

export default connect(applyState)(OrdersEdit);