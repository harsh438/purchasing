import React from 'react';
import { Link } from 'react-router';
import { assign, get, map, omit } from 'lodash';
import { renderSelectOptions } from '../../utilities/dom';

export default class OrdersFilters extends React.Component {
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
            <label htmlFor="brand_name">Order Type</label>
            <select className="form-control"
                    id="order_type"
                    name="orderType"
                    value={this.getFilter('orderType')}>
              <option value=""> -- select order type -- </option>
              {renderSelectOptions(this.props.orderTypes)}
            </select>
          </div>

          <div className="form-group col-md-2">
            <label htmlFor="brand_name">Order Name</label>
            <input className="form-control"
                    id="name"
                    name="name"
                    value={this.getFilter('name')} />
          </div>

          <div className="form-group col-md-4"
               style={{ marginTop: '1.74em' }}>
            <div className="btn-group"
                 style={{ width: '70%' }}>
              <button className="btn btn-primary"
                      disabled={this.state.submitting}
                      style={{ width: '70%' }}>
                {this.submitText()}
              </button>

              <Link to="/orders"
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

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFilterOrders(this.state.filters);
  }

  setFilter(field, value) {
    const filters = assign({}, this.state.filters, { [field]: value });
    this.setState({ filters });
  }

  getFilter(field) {
    return get(this.state.filters, field, '');
  }
}
