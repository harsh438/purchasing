import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
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
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/vendors">Brands</Link>
              &nbsp;/ Add brand
            </h1>
          </div>
        </div>
        <div className="row">
          <div className="col-md-6">
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

function applyState({ vendors }) {
  return vendors;
}

export default connect(applyState)(VendorsNew);
