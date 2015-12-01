import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import VendorsForm from './_form';
import { createVendor } from '../../actions/vendors';

class VendorsNew extends React.Component {
  componentWillMount() {
    this.state = { creatingVendor: false };
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.creatingVendor && nextProps.supplier) {
      this.props.history.pushState(null, `/suppliers/${nextProps.supplier.id}/edit`);
    }
  }

  render() {
    return (
      <div className="suppliers_new container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-4 col-md-offset-4">
            <VendorsForm title="Create Vendor"
                           submitText="Add Vendor"
                           onSubmitVendor={this.handleCreateVendor.bind(this)} />
          </div>
        </div>
      </div>
    );
  }

  handleCreateVendor(supplier) {
    this.setState({ creatingVendor: true });
    this.props.dispatch(createVendor(supplier));
  }
}

function applyState({ supplier }) {
  return supplier;
}

export default connect(applyState)(VendorsNew);
