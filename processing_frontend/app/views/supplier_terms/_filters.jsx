import React from 'react';
import { assign, get, map, omit } from 'lodash';
import Select from 'react-select';

export default class SupplierTermsFilters extends React.Component {
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
    let state = {};
    ['suppliers', 'brands', 'seasons'].forEach((key) => {
      state[key] = map(nextProps[key], (obj) => {
        return { label: obj.name, value: obj.id };
      });
    });
    this.setState(state);
  }

  render() {
    return (<form className="form clearfix"
              onChange={this.handleFormChange.bind(this)}
              onSubmit={this.handleFormSubmit.bind(this)}
              >
          <div className="form-group col-md-2">
            <label htmlFor="suppliers">Supplier</label>
            <Select id="suppliers"
                    name="suppliers"
                    multi
                    onChange={this.handleMultiSelectChange.bind(this, 'suppliers')}
                    value={this.getFilter('suppliers')}
                    options={this.state.suppliers} />
          </div>
          <div className="form-group col-md-2">
            <label htmlFor="vendor_ids">Brands</label>
            <Select id="suppliers"
                    name="vendor_ids"
                    multi
                    onChange={this.handleMultiSelectChange.bind(this, 'vendor_ids')}
                    value={this.getFilter('vendor_ids')}
                    options={this.state.brands} />
          </div>

          <div className="form-group col-md-2">
            <label htmlFor="seasons">Seasons</label>
            <Select id="suppliers"
                    name="seasons"
                    multi
                    onChange={this.handleMultiSelectChange.bind(this, 'seasons')}
                    value={this.getFilter('seasons')}
                    options={this.state.seasons} />
          </div>
          <div className="form-group col-md-2">
            <label htmlFor="seasons">Only Default Terms</label>
            <input className="form-control"
                   type="checkbox"
                   name="default"
                   checked={!!+(this.getFilter('default'))}
                   onChange={this.handleCheckboxChange.bind(this)}
                   />
          </div>

          <div className="form-group col-md-2"
               style={{ marginTop: '1.74em' }}>
            <button className="btn btn-success"
                    style={{ width: '100%' }}
                    disabled={this.state.submitting}>
                Search
            </button>
          </div>
     </form>);
  }

  handleMultiSelectChange(field, value) {
    this.handleFormChange({ target: { name: field, value } });
  }

  handleFormChange({ target }) {
    this.setFilter(target.name, target.value);
  }

  handleCheckboxChange(e) {
    e.stopPropagation();

    if (e.target.checked) {
      this.setFilter(e.target.name, 1);
    } else {
      this.state.filters[e.target.name] = 0;
      this.setState({ filters: this.state.filters });
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
    return get(this.state.filters, field, '');
  }
}
