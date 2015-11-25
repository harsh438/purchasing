import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SuppliersForm from './_form';
import { SuppliersTable } from './_table';
import { createSupplier, loadSuppliers } from '../../actions/suppliers';


export default class SuppliersIndex extends React.Component {
  componentWillMount() {
    this.state = { creatingSupplier: false };   
    this.loadPage(this.props.location.query.page); 
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.creatingSupplier && nextProps.supplier) {
      this.props.history.pushState(null, `/suppliers/${nextProps.supplier.id}/edit`);
    }
  }

  render() {
    return (
      <div className="suppliers_index" style={{ marginTop: '70px' }}>
        <SuppliersForm onSubmitSupplier={this.handleCreateSupplier.bind(this)} submitText="Create" supplierId="" />
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

  handleCreateSupplier(supplier) {
    this.setState({ creatingSupplier: true });    
    this.props.dispatch(createSupplier(supplier));
  }
}

function applyState({ suppliers, supplier }) {
  return assign({}, supplier, suppliers);
}

export default connect(applyState)(SuppliersIndex);
