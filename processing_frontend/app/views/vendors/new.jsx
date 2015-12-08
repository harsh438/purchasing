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
    if (this.state.creatingVendor && nextProps.vendor) {
      this.props.history.pushState(null, `/vendors/${nextProps.vendor.id}/edit`);
    }
  }

  render() {
    return (
      <div className="vendors_new container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-6 col-md-offset-3">
            <VendorsForm title="Create Brand"
                         submitText="Add Brand"
                         onSubmitVendor={this.handleCreateVendor.bind(this)} />
          </div>
        </div>
      </div>
    );
  }

  handleCreateVendor(vendor) {
    this.setState({ creatingVendor: true });
    this.props.dispatch(createVendor(vendor));
  }
}

function applyState({ vendor }) {
  return vendor;
}

export default connect(applyState)(VendorsNew);
