import React from 'react';
import { map } from 'lodash';

export default class SuppliersTable extends React.Component {
	render() {
  	return (
			<table className="table">
				<thead>
					<tr>
						<th>Name</th>
						<th className="text-right">Action</th>
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
        	<td>{ supplier.name }</td>
        	<td className="text-right">
						<a className="btn btn-default"
							 onClick={this.props.onEditSupplierButton.bind(this, supplier.id)}>
							Edit
						</a>
					</td>
        </tr>
      );
    });
  }
}
