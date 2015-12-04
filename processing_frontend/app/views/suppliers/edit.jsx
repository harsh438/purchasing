import React from 'react';
import { connect } from 'react-redux';
import { at, assign, compact, flatten, map } from 'lodash';
import { loadSupplier,
         editSupplier,
         saveSupplierContact,
         saveSupplierTerms } from '../../actions/suppliers';
import { loadSeasons } from '../../actions/filters';
import SuppliersForm from './_form';
import SupplierContactsTable from '../suppliers_contacts/_table';
import SupplierTermsDefault from '../supplier_terms/_default';

class SuppliersEdit extends React.Component {
  componentWillMount () {
    this.state = { editingSupplier: false };
    this.props.dispatch(loadSupplier(this.props.params.id));
    this.props.dispatch(loadSeasons());
  }

  render() {
    return (
      <div className="suppliers_edit" style={{ marginTop: '70px' }}>
        <div className="col-md-6">
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">{this.props.supplier.name}</h3>
            </div>
            <div className="panel-body">
              {this.renderSupplier()}
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <SupplierTermsDefault supplier={this.props.supplier}
                                seasons={this.props.seasons}
                                onTermsSave={this.handleTermsSave.bind(this)} />

          <SupplierContactsTable supplier={this.props.supplier}
                                 onContactAdd={this.handleContactSave.bind(this)}
                                 onContactEdit={this.handleContactSave.bind(this)} />
        </div>
      </div>
    );
  }

  renderSupplier() {
    if (this.state.editingSupplier) {
      return (
        <SuppliersForm title="Edit Supplier"
                       submitText="Save"
                       supplier={this.props.supplier}
                       onSubmitSupplier={this.handleSupplierEdit.bind(this)} />
      );
    } else {
      return (
        <div>
          <table className="table">
            <tbody>
              <tr>
                <th>Returns Address</th>
                <td>{this.renderReturnsAddress()}</td>
              </tr>

              <tr>
                <th>Returns Process</th>
                <td>{this.props.supplier.returnsProcess}</td>
              </tr>

              <tr>
                <th>Invoicer name</th>
                <td>{this.props.supplier.invoicerName}</td>
              </tr>

              <tr>
                <th>Account Number</th>
                <td>{this.props.supplier.accountNumber}</td>
              </tr>

              <tr>
                <th>Country of Origin</th>
                <td>{this.props.supplier.countryOfOrigin}</td>
              </tr>

              <tr>
                <th>Discontinued?</th>
                <td>{this.props.supplier.discontinued ? '✔' : '✘'}</td>
              </tr>
            </tbody>
          </table>

          <button className="btn btn-success"
                   onClick={() => this.setState({ editingSupplier: true })}>
            Edit supplier
          </button>
        </div>
      );
    }
  }

  renderReturnsAddress() {
    const addressParts = compact(at(this.props.supplier, ['returnsAddressName',
                                                          'returnsAddressNumber',
                                                          'returnsAddress1',
                                                          'returnsAddress2',
                                                          'returnsAddress3',
                                                          'returnsPostalCode']));

    return flatten(map(addressParts, part => [part, (<br />)]));
  }

  handleContactSave(contact) {
    this.props.dispatch(saveSupplierContact(this.props.supplier.id, contact));
  }

  handleSupplierEdit(supplier) {
    this.setState({ editingSupplier: false });
    this.props.dispatch(editSupplier(supplier));
  }

  handleTermsSave(terms) {
    this.props.dispatch(saveSupplierTerms(this.props.supplier.id, terms));
  }
}

function applyState({ filters, supplier }) {
  return assign({}, filters, supplier);
}

export default connect(applyState)(SuppliersEdit);
