import React from 'react';
import NumberedPagination from '../pagination/_numbered';
import { map } from 'lodash';

export class SuppliersTable extends React.Component {
	componentWillMount() {
	}

	render() {
    	return (
	    	<div className="panel panel-default pull-left col-xs-6">
	    			<div className="panel-heading">
	    				<h3 className="panel-title">Suppliers List</h3>
	    			</div>
	    			<div className="panel-body">
	    				<table className="table">
	    					<thead>
		    					<tr>
		    						<th>Name</th>
		    						<th>Action</th>
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
	    	</div>
    	);
  }

  renderRows() {
  	var id = 0;
    return map(this.props.suppliers, (supplier) => {
      id++;
      return (
        <tr key={ id }>
        	<td>{ supplier.name }</td>
        	<td><a className="btn btn-default" onClick={ () => this.props.onEditSupplierButton(supplier.supplier_id) }>Edit</a></td>
        </tr>
      );
    });
  }
}
