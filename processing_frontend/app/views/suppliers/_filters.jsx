import React from 'react';
import { Link } from 'react-router';
import { assign, get, map, omit } from 'lodash';
import { renderSelectOptions } from '../../utilities/dom';

export default class SuppliersFilters extends React.Component {
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
            <label htmlFor="supplier_name">Supplier Name</label>
            <input className="form-control"
                   id="supplier_name"
                   name="name"
                   value={this.getFilter('name')} />
          </div>

          <div className="form-group col-md-2">
            <label htmlFor="vendorId">Brand</label>
            <select className="form-control"
                    id="vendorId"
                    name="vendorId"
                    value={this.getFilter('vendorId')}>
              <option value=""> -- select brand -- </option>
              {renderSelectOptions(this.props.brands)}
            </select>
          </div>

          <div className="form-group col-md-2">
            <label htmlFor="buyerId">Buyer</label>
            <select className="form-control"
                    id="buyerName"
                    name="buyerName"
                    value={this.getFilter('buyerName')}>
              <option value=""> -- select buyer -- </option>
              {renderSelectOptions(this.props.buyers)}
            </select>
          </div>

          <div className="form-group col-md-2">
            <label htmlFor="assistantName">Buyer Assistant</label>
            <select className="form-control"
                    id="assistantName"
                    name="assistantName"
                    value={this.getFilter('assistantName')}>
              <option value=""> -- select assistant -- </option>
              {renderSelectOptions(this.props.buyerAssistants)}
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
          </div>

          <div className="form-group col-md-2"
               style={{ marginTop: '2.2em' }}>
            <Link to="/suppliers">clear filters</Link>
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
    this.props.onFilterSuppliers(this.state.filters);
  }

  setFilter(field, value) {
    const filters = assign({}, this.state.filters, { [field]: value });
    this.setState({ filters });
  }

  getFilter(field) {
    return get(this.state.filters, field, '');
  }
}
