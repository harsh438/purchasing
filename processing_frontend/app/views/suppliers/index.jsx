import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SuppliersForm from './_form';
import { createSupplier } from '../../actions/suppliers';

export default class SuppliersIndex extends React.Component {
  componentWillMount() {
    this.state = { creatingSupplier: false };    
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.creatingSupplier && nextProps.supplier) {
      this.props.history.pushState(null, `/suppliers/${nextProps.supplier.id}/edit`);
    }
  }

  render() {
    return (
      <div className="suppliers_index" style={{ marginTop: '70px' }}>
        <SuppliersForm onSubmitSupplier={this.handleCreateSupplier.bind(this)} submitText="Create"/>
      </div>
    );
  }

  handleCreateSupplier(supplier) {
    this.setState({ creatingSupplier: true });    
    this.props.dispatch(createSupplier(supplier));
  }  
}

function applyState({ suppliers, supplier }) {
  return assign({}, suppliers, supplier);
}

export default connect(applyState)(SuppliersIndex);
