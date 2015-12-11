import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { map, assign } from 'lodash';
import { loadVendor, editVendor } from '../../actions/vendors';
import { loadSeasons, loadSuppliers } from '../../actions/filters';
import VendorsForm from './_form';
import VendorsAssociateSupplierForm from './_associate_supplier_form';
import VendorsSupplierTable from './_supplier_table';

class VendorsEdit extends React.Component {
  componentWillMount () {
    this.state = { editingTerms: false };
    this.props.dispatch(loadVendor(this.props.params.id));
    this.props.dispatch(loadSeasons());
    this.props.dispatch(loadSuppliers());
  }

  render() {
    return (
      <div className="vendors_edit container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/vendors">Brands</Link>
              &nbsp;/ {this.props.vendor.name}
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <VendorsForm title="Edit Brand"
                         submitText="Save"
                         vendor={this.props.vendor}
                         onSubmitVendor={this.handleEditVendor.bind(this)} />
          </div>

          <div className="col-md-6">
            <VendorsAssociateSupplierForm onAssociateSupplier={this.handleAssociateSupplier.bind(this)}
                                          suppliers={this.props.suppliers} />
            <VendorsSupplierTable suppliers={this.props.vendor.suppliers} />
          </div>
        </div>
      </div>
    );
  }

  handleClickEditVendor(id) {
    this.props.history.pushState(null, `/vendors/${id}/edit`);
  }

  handleEditVendor(vendor) {
    this.props.dispatch(editVendor(vendor));
  }

  handleAssociateSupplier(supplierId) {
    const { id, suppliers } = this.props.vendor;
    const supplierIds = [...map(suppliers, 'id'), supplierId];
    this.props.dispatch(editVendor({ id, supplierIds }));
  }
}

function applyState({ filters, vendor }) {
  return assign({}, filters, vendor);
}

export default connect(applyState)(VendorsEdit);
