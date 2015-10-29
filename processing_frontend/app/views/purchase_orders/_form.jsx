import React from 'react';
import Select from 'react-select';

export default class PurchaseOrdersForm extends React.Component {
  render () {
    const className = `col-md-${this.props.columns}`;

    return (
      <div className={className}>
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Search Purchase Orders</h3>
          </div>

          <div className="panel-body">
            <form className="form">
              <div className="form-group">
                <label htmlFor="brand">Brand</label>
                <select className="form-control"
                        name="brand"
                        value={this.props.currentBrand}>
                  <option> -- select brand -- </option>
                  {this.brandOptions()}
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

  brandOptions () {
    return this.props.brands.map(function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }
}
