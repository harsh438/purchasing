import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class SuppliersTable extends React.Component {
	render() {
  	return (
			<table className="table">
				<thead>
					<tr>
						<th>Name</th>
            <th className="text-center">Created</th>
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
    return map(this.props.suppliers, (supplier, i) => {
      return (
        <tr key={i}>
        	<td>
          <Link to={`/suppliers/${supplier.id}/edit`}>
            {supplier.name}
          </Link>
          </td>
          <td className="text-center">
            { supplier.createdAt }
          </td>
          <td className="text-center">{ supplier.discontinued ? '✘' : '' }</td>
        	<td className="text-center">
            <Link className="btn btn-default" to={`/suppliers/${supplier.id}/edit`}>
              Edit
            </Link>
					</td>
        </tr>
      );
    });
  }
}
