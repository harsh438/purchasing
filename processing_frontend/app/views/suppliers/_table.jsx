import React from 'react';
import NumberedPagination from '../pagination/_numbered';
import { map } from 'lodash';

export class SuppliersTable extends React.Component {
	render() {
  	return (
			<div className="suppliers_table">
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
				<NumberedPagination activePage={this.props.activePage}
                      index={this.props.index}
                      totalPages={this.props.totalPages} />
    	</div>
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
