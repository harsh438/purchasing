import React from 'react';
import Select from 'react-select';
import serialize from 'form-serialize';

export default class PurchaseOrdersForm extends React.Component {
  componentWillMount () {
    this.setStateFromQuery(this.props.query);
  }

  componentWillReceiveProps({ query }) {
    this.setStateFromQuery(query);
  }

  render () {
    const className = `col-md-${this.props.columns}`;

    return (
      <div className={className}>
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Search Purchase Orders</h3>
          </div>

          <div className="panel-body">
            <form onSubmit={this.handleSubmit.bind(this)} className="form">
              <div className="form-group">
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

              <div className="form-group">
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

              <div className="form-group">
                <button className="btn btn-success">Search</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }

  setStateFromQuery (query) {
    this.setState({ brand: query.brand, category: query.category });
  }

  options (options) {
    return options.map(function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  handleChange (field, { target }) {
    this.setState({ [field]: target.value });
  }

  handleSubmit (e) {
    e.preventDefault();
    this.props.history.pushState(null, '/', this.state);
  }
}
