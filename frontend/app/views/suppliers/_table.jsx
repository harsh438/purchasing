import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class SuppliersTable extends React.Component {
  render() {
    return (
      <table className="table table-hover">
        <thead>
          <tr>
            <th>Name</th>
            <th>Brands</th>
            <th className="text-center" style={{ width: '15%' }}>Discontinued</th>
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
          <td>
            {this.vendorNames(supplier.vendors)}
          </td>
          <td className="text-center">{supplier.discontinued ? '✔' : '✘'}</td>
        </tr>
      );
    });
  }

  vendorNames(vendors) {
    return map(vendors, vendor => vendor.name).join(', ');
  }
}
