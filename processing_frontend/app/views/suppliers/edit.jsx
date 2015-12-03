import React from 'react';
import { connect } from 'react-redux';
import { at, assign, compact, flatten, map } from 'lodash';
import { loadSupplier,
         editSupplier,
         saveSupplierContact,
         saveTerms } from '../../actions/suppliers';
import { loadSeasons } from '../../actions/filters';
import SuppliersForm from './_form';
import SupplierContactsTable from '../suppliers_contacts/_table';
import SupplierTerms from '../supplier_terms/_terms';
import SupplierTermsForm from '../supplier_terms/_form';
import { Link } from 'react-router';

class SuppliersEdit extends React.Component {
  componentWillMount () {
    this.state = { editingSupplier: false,
                   editingTerms: false };
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
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">Default Terms</h3>
            </div>
            <div className="panel-body">
              {this.renderTerms()}
            </div>
          </div>

          <SupplierContactsTable supplier={this.props.supplier}
                                 onEditContact={this.handleOnSaveContact.bind(this)}
                                 onAddContact={this.handleOnSaveContact.bind(this)}/>
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
                       onSubmitSupplier={this.handleOnEditSupplier.bind(this)} />
      );
    } else {
      return (
        <p>
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
        </p>
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

  renderTerms() {
    if (this.state.editingTerms) {
      return (
        <SupplierTermsForm terms={this.props.supplier.defaultTerms}
                           seasons={this.props.seasons}
                           onFormSubmit={this.handleSaveTerms.bind(this)} />
      );
    } else if (this.props.supplier.defaultTerms) {
      return (
        <div>
          <SupplierTerms terms={this.props.supplier.defaultTerms} />

          <p>
            <button className="btn btn-success"
                     onClick={() => this.setState({ editingTerms: true })}>
              Edit terms
            </button>

            <Link className="btn btn-default pull-right" to={`/suppliers/${this.props.supplier.id}/terms`}>
              View terms history
            </Link>
          </p>
        </div>
      );
    } else {
      return (
        <div>
          <p>
            <em>This supplier does not have any terms</em>
          </p>

          <p>
            <button className="btn btn-success"
                    onClick={() => this.setState({ editingTerms: true })}>
              Add terms
            </button>
          </p>
        </div>
      );
    }
  }

  handleOnSaveContact(contact) {
    this.props.dispatch(saveSupplierContact(this.props.supplier, contact));
  }

  handleClickEditSupplier(id) {
    this.props.history.pushState(null, `/suppliers/${id}/edit`);
  }

  handleOnEditSupplier(supplier) {
    this.setState({ editingSupplier: false });
    this.props.dispatch(editSupplier(supplier));
  }

  handleSaveTerms(terms) {
    this.setState({ editingTerms: false });
    this.props.dispatch(saveTerms(this.props.supplier.id, terms));
  }
}

function applyState({ filters, supplier }) {
  return assign({}, filters, supplier);
}

export default connect(applyState)(SuppliersEdit);
