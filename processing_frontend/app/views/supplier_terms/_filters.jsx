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
    this.setState({ suppliers: map(nextProps.suppliers, (obj) => {
      return { label: obj.name, value: obj.id };
    })});
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
