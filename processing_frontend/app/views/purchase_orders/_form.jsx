import React from 'react';

export default class PurchaseOrdersForm extends React.Component {
  render () {
    const className = `col-md-${this.props.columns}`;
    return (
      <div className={className}>
        <div className="panel panel-default">
          <div className="panel-heading">
            Search Purchase Orders
          </div>

          <div className="panel-body">
            <form className="form">
              <button className="btn btn-success">Search</button>
            </form>
          </div>
        </div>
      </div>
    );
  }
}
