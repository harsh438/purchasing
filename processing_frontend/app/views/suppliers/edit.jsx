import React from 'react';
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import SuppliersForm from './_form';
import { SuppliersTable } from './_table';
import { loadSupplier, loadSuppliers } from '../../actions/suppliers';

class SuppliersEdit extends React.Component {
	componentWillMount () {
		this.props.dispatch(loadSupplier(this.props.params.id));
    this.loadPage(this.props.location.query.page); 
    this.setState({ supplierId: this.props.params.id });    
	}

  componentWillReceiveProps(nextProps) {
    this.props.dispatch(loadSupplier(this.props.params.id));
  }

	render() {
    	return (
        <div className="suppliers_edit" style={{ marginTop: '70px' }}>
    		  <SuppliersForm submitText="Edit"
  									     supplier={this.props.supplier} />
          <SuppliersTable index={this}
                        suppliers={this.props.suppliers}
                        totalPages={this.props.totalPages}
                        activePage={this.props.activePage}
                        onEditSupplierButton={this.handleOnEditSupplier.bind(this)} />
        </div>
    	);
  }

  loadPage(page) {
    this.props.dispatch(loadSuppliers(page || 1));
  }

  handleOnEditSupplier(id) {
      this.props.history.pushState(null, `/suppliers/${id}/edit`);    
  }  
}

function applyState({ suppliers, supplier }) {
  console.log('applystateEdit', suppliers, supplier);
  return assign({}, supplier, suppliers);
}

export default connect(applyState)(SuppliersEdit);
 