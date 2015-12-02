import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class VendorsTable extends React.Component {
	render() {
  	return (
			<table className="table">
				<thead>
					<tr>
						<th>Name</th>
            <th className="text-center">Created</th>
            <th className="text-center">Updated</th>
            <th className="text-center">Discontinued</th>
						<th className="text-center">Action</th>
					</tr>
				</thead>
				<tbody>
					{ this.renderRows() }
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
          <td className="text-center">
            {vendor.createdAt}
          </td>
          <td className="text-center">
            {vendor.updatedAt}
          </td>
          <td className="text-center">{vendor.discontinued ? '✔' : '✘'}</td>
        	<td className="text-center">
            <Link className="btn btn-default" to={`/vendors/${vendor.id}/edit`}>
              Edit
            </Link>
					</td>
        </tr>
      );
    });
  }
}
