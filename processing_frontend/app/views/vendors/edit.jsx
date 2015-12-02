import React from 'react';
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import { loadVendor, editVendor } from '../../actions/vendors';
import { loadSeasons } from '../../actions/filters';
import VendorsForm from './_form';

class VendorsEdit extends React.Component {
  componentWillMount () {
    this.state = { editingTerms: false};
    this.props.dispatch(loadVendor(this.props.params.id));
    this.props.dispatch(loadSeasons());
  }

  render() {
    return (
      <div className="vendors_edit" style={{ marginTop: '70px' }}>
        <div className="col-xs-6">
          <VendorsForm title="Edit Vendor"
                       submitText="Save"
                       vendor={this.props.vendor}
                       onSubmitVendor={this.handleOnEditVendor.bind(this)} />
        </div>
      </div>
    );
  }

  handleClickEditVendor(id) {
    this.props.history.pushState(null, `/vendors/${id}/edit`);
  }

  handleOnEditVendor(vendor) {
    this.props.dispatch(editVendor(vendor));
  }
}

function applyState({ filters, vendor }) {
  return assign({}, filters, vendor);
}

export default connect(applyState)(VendorsEdit);
