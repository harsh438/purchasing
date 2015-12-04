import React from 'react';
import { Link } from 'react-router';
import { assign, get, map, omit } from 'lodash';

export default class VendorsFilters extends React.Component {
  componentWillMount() {
    this.state = { filters: (this.props.filters || {}),
                   submitting: false };
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.filters !== nextProps.filters) {
      this.setState({ filters: (nextProps.filters || {}) });
    } else {
      this.setState({ submitting: false });
    }
  }

  render() {
    return (
      <form className="form clearfix"
            onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <div className="row no_gutter">
          <div className="form-group col-md-2">
            <label htmlFor="brand_name">Brand Name</label>
            <input className="form-control"
                   id="brand_name"
                   name="name"
                   value={this.getFilter('name')} />
          </div>

          <div className="form-group col-md-2">
            <label htmlFor="vendor_id">Supplier</label>
            <select className="form-control"
                    id="supplier_id"
                    name="supplierId"
                    value={this.getFilter('supplierId')}>
              <option value=""> -- select supplier -- </option>
              {this.renderSelectOptions(this.props.suppliers)}
            </select>
          </div>

          <div className="form-group col-md-2"
               style={{ paddingTop: '1.6em' }}>
            <div className="checkbox">
              <label>
                <input type="checkbox"
                       name="discontinued"
                       value="1"
                       className="checkbox"
                       checked={this.getFilter('discontinued')}
                       onChange={this.handleCheckboxChange.bind(this)} />

                Discontinued
              </label>
            </div>
          </div>

          <div className="form-group col-md-2"
               style={{ marginTop: '1.74em' }}>
            <button className="btn btn-success"
                    style={{ width: '100%' }}
                    disabled={this.state.submitting}>
              {this.submitText()}
            </button>

            <div className="text-right"
                 style={{ marginTop: '1em' }}>
              <Link to="/vendors">clear filters</Link>
            </div>
          </div>
        </div>
      </form>
    );
  }

  submitText() {
    if (this.state.submitting) {
      return 'Searching...';
    } else {
      return 'Search';
    }
  }

  renderSelectOptions(options) {
    return map(options, function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  handleFormChange({ target }) {
    this.setFilter(target.name, target.value);
  }

  handleCheckboxChange(e) {
    e.stopPropagation();

    if (e.target.checked) {
      this.handleFormChange(e);
    } else {
      this.setState({ filters: omit(this.state.filters, e.target.name) });
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFilterVendors(this.state.filters);
  }

  setFilter(field, value) {
    const filters = assign({}, this.state.filters, { [field]: value });
    this.setState({ filters });
  }

  getFilter(field) {
    return get(this.state.filters, field, '');
  }
}
