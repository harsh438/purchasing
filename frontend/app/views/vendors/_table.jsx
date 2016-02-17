import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class VendorsTable extends React.Component {
  render() {
    return (
      <table className="table table-hover">
        <thead>
          <tr>
            <th>Name</th>
            <th>Suppliers</th>
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
    return map(this.props.vendors, (vendor, i) => {
      return (
        <tr key={i}>
          <td>
            <Link to={`/vendors/${vendor.id}/edit`}>
              {vendor.name}
            </Link>
          </td>
          <td>
            {this.supplierNames(vendor.suppliers)}
          </td>
          <td className="text-center">{vendor.discontinued ? '✔' : '✘'}</td>
        </tr>
      );
    });
  }

  supplierNames(suppliers) {
    return map(suppliers, supplier => supplier.name).join(', ');
  }
}
