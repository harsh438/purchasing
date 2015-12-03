import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class VendorsSupplierTable extends React.Component {
  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Suppliers</h3>
        </div>

        <div className="panel-body">
          {this.renderTable()}
        </div>
      </div>
    );
  }

  renderTable() {
    console.log(this.props)

    if (this.props.suppliers.length === 0) {
      return (<em>No suppliers associated</em>);
    }

    return (
      <table className="table">
        <thead>
          <tr>
            <th>Supplier Name</th>
          </tr>
        </thead>
        <tbody>
          {this.renderRows()}
        </tbody>
      </table>
    );
  }

  renderRows() {
    return map(this.props.suppliers, (supplier, i) => {
      return (
        <tr key={i}>
          <td>
            <Link to={`/suppliers/${supplier.id}/edit`}>
              {supplier.name}
            </Link>
          </td>
        </tr>
      );
    });
  }
}
