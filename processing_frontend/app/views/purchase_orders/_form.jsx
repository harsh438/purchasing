import React from 'react';

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
              <select>
                {this.brandOptions()}
              </select>
              <button className="btn btn-success">Search</button>
            </form>
          </div>
        </div>
      </div>
    );
  }

  brandOptions () {
    return this.props.brands.map(function ({ id, name }) {
      return (
        <option value={id} key={id}>{name}</option>
      );
    });
  }
}
