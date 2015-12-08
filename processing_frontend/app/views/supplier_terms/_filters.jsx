import React from 'react';
import { Link } from 'react-router';
import Select from 'react-select';
import { assign, get, map, omit, snakeCase, trim } from 'lodash';
import { renderMultiSelectOptions } from '../../utilities/dom';

export default class SupplierTermsFilters extends React.Component {
  componentWillMount() {
    this.state = { filters: (this.props.filters || {}),
                   submitting: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });

    if (this.props.filters !== nextProps.filters) {
      this.setState({ filters: (nextProps.filters || {}) });
    }
  }

  render() {
    return (
      <form className="form clearfix"
            onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <div className="form-group col-md-2">
          <label htmlFor="supplierId">Supplier</label>
          <Select id="supplierId"
                  name="supplierId"
                  multi
                  onChange={this.handleMultiSelectChange.bind(this, 'supplierId')}
                  value={this.getFilter('supplierId')}
                  options={renderMultiSelectOptions(this.props.suppliers)} />
        </div>

        <div className="form-group col-md-2">
          <label htmlFor="vendorId">Brands</label>
          <Select id="suppliers"
                  name="vendorId"
                  multi
                  onChange={this.handleMultiSelectChange.bind(this, 'vendorId')}
                  value={this.getFilter('vendorId')}
                  options={renderMultiSelectOptions(this.props.brands)} />
        </div>

        <div className="form-group col-md-2">
          <label htmlFor="season">Seasons</label>
          <Select id="season"
                  name="season"
                  multi
                  onChange={this.handleMultiSelectChange.bind(this, 'season')}
                  value={this.getFilter('season')}
                  options={renderMultiSelectOptions(this.props.seasons)} />
        </div>

        <div className="form-group col-md-2">
          <label htmlFor="terms">Terms</label>
          <Select id="terms"
                  name="terms"
                  multi
                  onChange={this.handleMultiSelectChange.bind(this, 'terms')}
                  value={this.getFilter('terms')}
                  options={renderMultiSelectOptions(this.props.supplierTermsList)} />
        </div>

        <div className="form-group col-md-2"
             style={{ paddingTop: '1.6em' }}>
          <div className="checkbox">
            <label>
              <input className="checkbox"
                     type="checkbox"
                     name="default"
                     value="1"
                     checked={this.getFilter('default')}
                     onChange={this.handleCheckboxChange.bind(this)} />
              Default terms only
            </label>
          </div>
        </div>

        <div className="form-group col-md-2"
             style={{ marginTop: '1.74em' }}>
          <button className="btn btn-success"
                  style={{ width: '100%' }}
                  disabled={this.state.submitting}>
              Search
          </button>

          <div className="text-right"
               style={{ marginTop: '1em' }}>
            <Link to="/terms">clear filters</Link>
          </div>
        </div>
      </form>
    );
  }

  handleFormChange({ target }) {
    this.setFilter(target.name, target.value);
  }

  handleMultiSelectChange(field, value) {
    const values = value ? value.split(',') : [];
    this.setFilter(field, map(values, trim));
  }

  handleCheckboxChange(e) {
    e.stopPropagation();

    if (e.target.checked) {
      this.handleFormChange(e);
    } else {
      const filters = assign({}, this.state.filters, { [e.target.name]: '0' });
      this.setState({ filters });
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFilter(this.state.filters);
  }

  setFilter(field, value) {
    const filters = assign({}, this.state.filters, { [field]: value });
    this.setState({ filters });
  }

  getFilter(field) {
    switch (field) {
    case 'default':
      return get(this.state.filters, field, '1') === '1';
    default:
      return get(this.state.filters, field, '');
    }
  }
}
