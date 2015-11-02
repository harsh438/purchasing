import CheckboxGroup from 'react-checkbox-group';
import React from 'react';
import { Link } from 'react-router';

export default class PurchaseOrdersForm extends React.Component {
  componentWillMount () {
    this.setStateFromQuery(this.props.query);
  }

  componentWillReceiveProps({ query }) {
    this.setStateFromQuery(query);
  }

  render () {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Search Purchase Orders</h3>
        </div>

        <div className="panel-body">
          <form className="form" onSubmit={this.handleSubmit.bind(this)}>
            <div className="row no_gutter">
              <div className="form-group col-md-3">
                <label htmlFor="brand">Brand</label>

                <select className="form-control"
                        id="brand"
                        name="brand"
                        onChange={this.handleChange.bind(this, 'brand')}
                        value={this.state.brand}>
                  <option value=""> -- select brand -- </option>
                  {this.options(this.props.brands)}
                </select>
              </div>

              <div className="form-group col-md-3">
                <label htmlFor="category">Category</label>

                <select className="form-control"
                        id="category"
                        name="category"
                        onChange={this.handleChange.bind(this, 'category')}
                        value={this.state.category}>
                  <option value=""> -- select category -- </option>
                  {this.options(this.props.categories)}
                </select>
              </div>
              <div className="form-group col-md-2">
                <label htmlFor="poNumber">PO Number</label>

                <input className="form-control"
                       name="poNumber"
                       onChange={this.handleChange.bind(this, 'poNumber')}
                       type="search"
                       value={this.state.poNumber} />
              </div>

              <div className="form-group col-md-2">
                <label htmlFor="pid">PID</label>

                <input className="form-control"
                       name="pid"
                       onChange={this.handleChange.bind(this, 'pid')}
                       type="search"
                       value={this.state.pid} />
              </div>

              <div className="form-group col-md-2">
                <label htmlFor="sku">SKU</label>

                <input className="form-control"
                       name="sku"
                       onChange={this.handleChange.bind(this, 'sku')}
                       type="search"
                       value={this.state.sku} />
              </div>
            </div>

            <div className="row no_gutter">
              <div className="col-md-2 form-group">
                <label htmlFor="date_from">Date From</label>

                <input className="form-control"
                       name="date_from"
                       onChange={this.handleChange.bind(this, 'date_from')}
                       type="date"
                       value={this.state.date_from} />
              </div>

              <div className="col-md-2 form-group">
                <label htmlFor="date_until">Date Until</label>

                <input className="form-control"
                       name="date_until"
                       onChange={this.handleChange.bind(this, 'date_until')}
                       type="date"
                       value={this.state.date_until} />
              </div>

              <div className="col-md-2">
                <label htmlFor="gender">Gender</label>

                <select className="form-control"
                        id="gender"
                        name="gender"
                        onChange={this.handleChange.bind(this, 'gender')}
                        value={this.state.gender}>
                  <option value=""> -- select gender -- </option>
                  {this.options(this.props.genders)}
                </select>
              </div>

              <div className="col-md-2">
                <label htmlFor="orderType">Order Type</label>

                <select className="form-control"
                        id="orderType"
                        name="orderType"
                        onChange={this.handleChange.bind(this, 'orderType')}
                        value={this.state.orderType}>
                  <option value=""> -- select order type -- </option>
                  {this.options(this.props.orderTypes)}
                </select>
              </div>

              <div className="col-md-4" style={{ paddingTop: '2.2em' }}>
                <CheckboxGroup name="status"
                               ref="status"
                               value={this.state.status}
                               onChange={this.handleStatusChange.bind(this)}>
                  <div className="form-group">
                    <label className="status-label">
                      <input type="checkbox" value="cancelled" /> Cancelled
                    </label>
                    <label className="status-label">
                      <input type="checkbox" value="balance" /> Balance
                    </label>
                    <label className="status-label">
                      <input type="checkbox" value="received" /> Received
                    </label>
                    <label className="status-label">
                      <input type="checkbox" value="delivered" /> Delivered
                    </label>
                  </div>
                </CheckboxGroup>
              </div>
            </div>
            <div className="row">
              <div className="col-md-4">
                <label htmlFor="supplier">Supplier</label>

                <select className="form-control"
                        id="supplier"
                        name="supplier"
                        onChange={this.handleChange.bind(this, 'supplier')}
                        value={this.state.supplier}>
                  <option value=""> -- select supplier -- </option>
                  {this.options(this.props.suppliers)}
                </select>
              </div>
              <div className="col-md-4">
              </div>
              <div className="col-md-4 text-right">
               <button className="btn btn-success" style={{ marginTop: '1.74em', width: '100%' }}>
                  Search
                </button>

                <div style={{ marginTop: '1em' }}>
                  <Link to="/">
                    clear all filters
                  </Link>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }

  setStateFromQuery (query) {
    this.setState({ brand: query.brand || '',
                    category: query.category || '',
                    poNumber: query.poNumber || '',
                    pid: query.pid || '',
                    sku: query.sku || '',
                    date_from: query.date_from || '',
                    date_until: query.date_until || '',
                    status: query.status || [],
                    gender: query.gender || '',
                    orderType: query.orderType || '',
                    supplier: query.supplier || ''});
  }

  options (options) {
    return options.map(function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  handleStatusChange () {
    this.setState({ status: this.refs.status.getCheckedValues() });
  }

  handleChange (field, { target }) {
    this.setState({ [field]: target.value });
  }

  handleSubmit (e) {
    e.preventDefault();
    this.props.history.pushState(null, '/', this.state);
  }
}
