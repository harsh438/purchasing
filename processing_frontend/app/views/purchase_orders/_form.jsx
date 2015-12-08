import CheckboxGroup from 'react-checkbox-group';
import RadioGroup from 'react-radio-group';
import React from 'react';
import { Link } from 'react-router';
import Select from 'react-select';
import { assign, get, map, omit, trim } from 'lodash';
import { isEmptyObject } from '../../utilities/inspection';
import { renderSelectOptions,
         renderMultiSelectOptions } from '../../utilities/dom';

export default class PurchaseOrdersForm extends React.Component {
  componentWillMount() {
    this.setStateFromQuery(this.props.query);
  }

  componentWillReceiveProps({ query }) {
    this.setStateFromQuery(query);
  }

  render() {
    const filters = this.state.filters;

    return (
      <div className="form-container filters">
        <div className="panel panel-default">
          <div className="panel-body">
            <form className="form"
                  onChange={this.handleFormChange.bind(this)}
                  onSubmit={this.handleFormSubmit.bind(this)}>
              <div className="row no_gutter">
                <div className="form-group col-md-2">
                  <label htmlFor="brand">Brand</label>

                  <select className="form-control"
                          id="brand"
                          name="brand"
                          value={this.getFilter('brand')}>
                    <option value=""> -- select brand -- </option>
                    {renderSelectOptions(this.props.brands)}
                  </select>
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="category">Category</label>

                  <Select id="category"
                          name="category"
                          onChange={this.handleMultiSelectChange.bind(this, 'category')}
                          multi
                          value={this.getFilter('category')}
                          options={renderMultiSelectOptions(this.props.categories)} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="season">Season</label>

                  <select className="form-control"
                          id="season"
                          name="season"
                          value={this.getFilter('season')}>
                    <option value=""> -- select season -- </option>
                    {renderSelectOptions(this.props.seasons)}
                  </select>
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="poNumber">PO Number</label>

                  <input className="form-control"
                         name="poNumber"
                         id="poNumber"
                         type="search"
                         value={this.getFilter('poNumber')} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="pid">PID</label>

                  <input className="form-control"
                         name="pid"
                         id="pid"
                         type="search"
                         value={this.getFilter('pid')} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="sku">SKU</label>

                  <input className="form-control"
                         name="sku"
                         id="sku"
                         type="search"
                         value={this.getFilter('sku')} />
                </div>
              </div>

              <div className="row no_gutter">
                <div className="col-md-2 form-group">
                  <label htmlFor="dateFrom">Date From</label>

                  <input className="form-control"
                         name="dateFrom"
                         id="dateFrom"
                         type="date"
                         value={this.getFilter('dateFrom')} />
                </div>

                <div className="col-md-2 form-group">
                  <label htmlFor="dateUntil">Date Until</label>

                  <input className="form-control"
                         name="dateUntil"
                         id="dateUntil"
                         type="date"
                         value={this.getFilter('dateUntil')} />
                </div>

                <div className="col-md-2">
                  <label htmlFor="gender">Gender</label>

                  <Select id="gender"
                          name="gender"
                          onChange={this.handleMultiSelectChange.bind(this, 'gender')}
                          multi
                          value={this.getFilter('gender')}
                          options={renderMultiSelectOptions(this.props.genders)} />
                </div>

                <div className="col-md-2">
                  <label htmlFor="orderType">Order Type</label>

                  <select className="form-control"
                          id="orderType"
                          name="orderType"
                          value={this.getFilter('orderType')}>
                    <option value=""> -- select order type -- </option>
                    {renderSelectOptions(this.props.orderTypes)}
                  </select>
                </div>

                <div className="col-md-2">
                  <label htmlFor="supplier">Supplier</label>

                  <select className="form-control"
                          id="supplier"
                          name="supplier"
                          value={this.getFilter('supplier')}>
                    <option value=""> -- select supplier -- </option>
                    {renderSelectOptions(this.props.suppliers)}
                  </select>
                </div>

                <div className="col-md-2">
                  <label htmlFor="operator">Order Tool Number</label>

                  <input className="form-control"
                         name="operator"
                         id="operator"
                         type="search"
                         value={this.getFilter('operator')}
                         placeholder="OT_" />
                </div>
              </div>

              <div className="row">
                <div className="col-md-4" style={{ paddingTop: '0.5em' }}>
                  <label>Sort by</label>

                  <RadioGroup name="sortBy"
                              ref="sortBy"
                              selectedValue={this.state.sortBy}
                              onChange={() => 'noop'}>
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
                                 value={this.getFilter('status')}>
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
                  <button className="btn btn-success"
                          disabled={this.isSubmitDisabled()}
                          style={{ marginTop: '1.74em', width: '100%' }}>
                    {this.submitText()}
                  </button>

                  {this.renderClearFiltersLink()}
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }

  renderClearFiltersLink() {
    if (isEmptyObject(this.state.filters)) return;

    return (
      <div style={{ marginTop: '1em' }}>
        <Link to="/">
          clear all filters
        </Link>
      </div>
    );
  }

  isSubmitDisabled() {
    return this.props.loading || isEmptyObject(this.state.filters);
  }

  submitText() {
    if (this.props.loading) {
      return 'Searching...';
    } else {
      return 'Search';
    }
  }

  multiSelectOptions(options) {
    return map(options, function ({ id, name }) {
      return { value: id, label: name };
    });
  }

  handleMultiSelectChange(field, value) {
    const values = value ? value.split(',') : [];
    this.setFilter(field, map(values, trim));
  }

  handleFormChange({ target }) {
    switch (target.name) {
    case 'sortBy':
      return this.setState({ sortBy: target.value });
    case 'status':
      return this.setFilter('status', this.refs.status.getCheckedValues());
    default:
      return this.setFilter(target.name, target.value);
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.props.history.pushState(null, '/', { sortBy: this.state.sortBy,
                                              ...this.state.filters });
  }

  setStateFromQuery(query) {
    this.setState({ filters: omit(query, 'sortBy'),
                    sortBy: query.sortBy || 'drop_date_asc' });
  }

  getFilter(field) {
    switch (field) {
    case 'category':
    case 'gender':
      return get(this.state.filters, field, []).join(',');
    default:
      return get(this.state.filters, field, '');
    }
  }

  setFilter(field, value) {
    this.setState(state => ({ filters: assign({}, state.filters, { [field]: value }) }));
  }
}
