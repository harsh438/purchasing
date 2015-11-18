import CheckboxGroup from 'react-checkbox-group';
import RadioGroup from 'react-radio-group';
import React from 'react';
import { Link } from 'react-router';
import Select from 'react-select';
import { map } from 'lodash';

export default class PurchaseOrdersForm extends React.Component {
  componentWillMount () {
    this.setStateFromQuery(this.props.query);
  }

  componentWillReceiveProps({ loaded, query }) {
    this.setStateFromQuery(query);
  }

  render () {
    return (
      <div className="form-container filters">
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Search Purchase Orders</h3>
          </div>

          <div className="panel-body">
            <form className="form" onSubmit={this.handleSubmit.bind(this)}>
              <div className="row no_gutter">
                <div className="form-group col-md-2">
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

                <div className="form-group col-md-2">
                  <label htmlFor="category">Category</label>

                  <Select id="category"
                          name="category"
                          onChange={this.handleCategoryChange.bind(this)}
                          multi={true}
                          value={this.joinMultiSelectValues(this.state.category)}
                          options={this.multiSelectOptions(this.props.categories)} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="season">Season</label>

                  <select className="form-control"
                          id="season"
                          name="season"
                          onChange={this.handleChange.bind(this, 'season')}
                          value={this.state.season}>
                    <option value=""> -- select season -- </option>
                    {this.options(this.props.seasons)}
                  </select>
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="poNumber">PO Number</label>

                  <input className="form-control"
                         name="poNumber"
                         id="poNumber"
                         onChange={this.handleChange.bind(this, 'poNumber')}
                         type="search"
                         value={this.state.poNumber} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="pid">PID</label>

                  <input className="form-control"
                         name="pid"
                         id="pid"
                         onChange={this.handleChange.bind(this, 'pid')}
                         type="search"
                         value={this.state.pid} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="sku">SKU</label>

                  <input className="form-control"
                         name="sku"
                         id="sku"
                         onChange={this.handleChange.bind(this, 'sku')}
                         type="search"
                         value={this.state.sku} />
                </div>
              </div>

              <div className="row no_gutter">
                <div className="col-md-2 form-group">
                  <label htmlFor="dateFrom">Date From</label>

                  <input className="form-control"
                         name="dateFrom"
                         id="dateFrom"
                         onChange={this.handleChange.bind(this, 'dateFrom')}
                         type="date"
                         value={this.state.dateFrom} />
                </div>

                <div className="col-md-2 form-group">
                  <label htmlFor="dateUntil">Date Until</label>

                  <input className="form-control"
                         name="dateUntil"
                         id="dateUntil"
                         onChange={this.handleChange.bind(this, 'dateUntil')}
                         type="date"
                         value={this.state.dateUntil} />
                </div>

                <div className="col-md-2">
                  <label htmlFor="gender">Gender</label>

                  <Select id="gender"
                          name="gender"
                          onChange={this.handleGenderChange.bind(this)}
                          multi={true}
                          value={this.joinMultiSelectValues(this.state.gender)}
                          options={this.multiSelectOptions(this.props.genders)} />
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

                <div className="col-md-2">
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

                <div className="col-md-2">
                  <label htmlFor="operator">Order Tool Number</label>

                  <input className="form-control"
                         name="operator"
                         id="operator"
                         onChange={this.handleChange.bind(this, 'operator')}
                         type="search"
                         value={this.state.operator}
                         placeholder="OT_" />
                </div>
              </div>

              <div className="row">
                <div className="col-md-4" style={{ paddingTop: '0.5em' }}>
                  <label>Sort by</label>

                  <RadioGroup name="sortBy"
                              ref="sortBy"
                              selectedValue={this.state.sortBy}
                              onChange={this.handleSortChange.bind(this)}>
                    {Radio => (
                      <div className="form-group">
                        <label className="status-label">
                          <Radio value="product_id_desc" /> PID
                        </label>
                        <label className="status-label">
                          <Radio value="product_sku_desc" /> SKU
                        </label>
                         <label className="status-label">
                          <Radio value="drop_date_asc" /> Drop Date
                        </label>
                      </div>
                    )}
                  </RadioGroup>
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
                    </div>
                  </CheckboxGroup>
                </div>

                <div className="col-md-4 text-right">
                  {this.renderSubmit()}

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
      </div>
    );
  }

  renderSubmit() {
    if (this.props.loading) {
      return (
        <button className="btn btn-success"
                disabled="disabled"
                style={{ marginTop: '1.74em', width: '100%' }}>
          Searching...
        </button>
      );
    } else {
      return (
        <button className="btn btn-success"
                style={{ marginTop: '1.74em', width: '100%' }}>
          Search
        </button>
      );
    }
  }

  setStateFromQuery(query) {
    this.setState({ brand: query.brand || '',
                    category: query.category || [],
                    poNumber: query.poNumber || '',
                    pid: query.pid || '',
                    sku: query.sku || '',
                    dateFrom: query.dateFrom || '',
                    dateUntil: query.dateUntil || '',
                    status: query.status || [],
                    gender: query.gender || [],
                    orderType: query.orderType || '',
                    season: query.season || '',
                    supplier: query.supplier || '',
                    operator: query.operator || '',
                    sortBy: query.sortBy || 'drop_date_asc'});
  }

  multiSelectOptions (options) {
    let opts = map(options, function ({ id, name }) {
      return { value: id, label: name };
    });

    return opts;
  }

  options (options) {
    return map(options, function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  handleSortChange(value) {
    this.setState({ sortBy: value });
  }

  handleStatusChange() {
    this.setState({ status: this.refs.status.getCheckedValues() });
  }

  handleChange(field, { target }) {
    this.setState({ [field]: target.value });
  }

  splitMultiSelectValues(value) {
    if (!value) {
      return []
    }

    return map(value.split(','), (v) => { return v.trim() })
  }

  joinMultiSelectValues(values) {
    return values.join(',')
  }

  handleCategoryChange(value) {
    this.setState({ category: this.splitMultiSelectValues(value) });
  }

  handleGenderChange(value) {
    this.setState({ gender: this.splitMultiSelectValues(value) });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.history.pushState(null, '/', this.state);
  }
}
