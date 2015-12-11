import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SuppliersForm from './_form';
import { createSupplier } from '../../actions/suppliers';
import { Link } from 'react-router';

class SuppliersNew extends React.Component {
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
      <div className="suppliers_new container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/suppliers">Suppliers</Link>
              &nbsp;/ Add supplier
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="panel panel-default">
              <div className="panel-body">
                <SuppliersForm title="Create Supplier"
                               submitText="Add Supplier"
                               onSubmitSupplier={this.handleCreateSupplier.bind(this)} />
              </div>
            </div>
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
  return supplier;
}

export default connect(applyState)(SuppliersNew);
