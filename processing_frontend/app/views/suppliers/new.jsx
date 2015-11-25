import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SuppliersForm from './_form';
import { createSupplier } from '../../actions/suppliers';

class SuppliersNew extends React.Component {
  componentWillMount() {
    this.state = { creatingSupplier: false };
  }

  componentWillReceiveProps(nextProps) {
    console.log('componentWillReceiveProps', nextProps.supplier)
    if (this.state.creatingSupplier && nextProps.supplier) {
      this.props.history.pushState(null, `/suppliers/${nextProps.supplier.id}/edit`);
    }
  }

  render() {
      return (
        <div className="suppliers_new container-fluid"
             style={{ marginTop: '70px' }}>
          <div className="row">
            <div className="col-md-4 col-md-offset-4">
              <SuppliersForm submitText="Add Supplier"
                             onSubmitSupplier={this.handleCreateSupplier.bind(this)} />
            </div>
          </div>
        </div>
      );
  }

  handleCreateSupplier(supplier) {
    this.setState({ creatingSupplier: true });
    this.props.dispatch(createSupplier(supplier));
  }
}

function applyState({ supplier }) {
  return assign({}, supplier);
}

export default connect(applyState)(SuppliersNew);
