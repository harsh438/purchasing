import React from 'react';
import { Link } from 'react-router';
import { assign, get, map, omit } from 'lodash';
import { renderSelectOptions } from '../../utilities/dom';

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
            <label htmlFor="supplierId">Supplier</label>
            <select className="form-control"
                    id="supplier_id"
                    name="supplierId"
                    value={this.getFilter('supplierId')}>
              <option value=""> -- select supplier -- </option>
              {renderSelectOptions(this.props.suppliers)}
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

          <div className="form-group col-md-4"
               style={{ marginTop: '1.74em' }}>
            <div className="checkbox pull-left"
                 style={{ width: '30%' }}>
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

            <div className="btn-group pull-right"
                 style={{ width: '70%' }}>
              <button className="btn btn-primary"
                      disabled={this.state.submitting}
                      style={{ width: '70%' }}>
                {this.submitText()}
              </button>

              <Link to="/vendors"
                    className="btn btn-default"
                    style={{ width: '30%' }}>
                Reset
              </Link>
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
