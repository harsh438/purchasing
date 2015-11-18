import React from 'react';
import { assign } from 'lodash';
import { connect } from 'react-redux';
import { OrdersTable } from './_table';
import { loadOrders, createOrder, exportOrders } from '../../actions/orders';

class OrdersIndex extends React.Component {
  componentWillMount() {
    this.state = { creatingOrder: false };
    this.loadPage(this.props.location.query.page);
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.creatingOrder && nextProps.order) {
      this.props.history.pushState(null, `/orders/${nextProps.order.id}/edit`);
    }
  }

  render() {
    return (
      <div className="orders_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-6">
            <div className="panel panel-default">
              <div className="panel-heading">
                <h3 className="panel-title">Reorder</h3>
              </div>

              <div className="panel-body">
                <form className="form-inline"
                      onChange={this.handleFormChange.bind(this)}
                      onSubmit={this.handleFormSubmit.bind(this)}>
                  <div className="form-group">
                    <label htmlFor="order_name"
                           style={{ display: 'block' }}>
                      Order name (optional)
                    </label>

                    <input className="form-control"
                           id="order_name"
                           name="name"
                           style={{ width: '300px' }}
                           value={this.state.name} />

                    <button className="btn btn-success"
                            disabled={this.state.creatingOrder}
                            style={{ marginLeft: '1em' }}>
                      Create order
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <OrdersTable index={this}
                         orders={this.props.orders}
                         totalPages={this.props.totalPages}
                         activePage={this.props.activePage}
                         query={this.props.location.query}
                         onExportOrders={this.handleExportOrder.bind(this)} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page) {
    this.props.dispatch(loadOrders(page || 1));
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ creatingOrder: true });
    this.props.dispatch(createOrder(this.state));
  }

  handleExportOrder(orderIds) {
    this.props.dispatch(exportOrders(orderIds));
  }
}

function applyState({ orders, order }) {
  return assign({}, orders, order);
}

export default connect(applyState)(OrdersIndex);
