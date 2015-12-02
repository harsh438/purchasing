import React from 'react';
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import { loadSupplier,
         editSupplier,
         saveSupplierContact,
         saveTerms } from '../../actions/suppliers';
import { loadSeasons } from '../../actions/filters';
import SuppliersForm from './_form';
import SupplierContacts from '../suppliers_contacts/_table';
import SupplierTerms from '../supplier_terms/_terms';
import SupplierTermsForm from '../supplier_terms/_form';
import { Link } from 'react-router';

class SuppliersEdit extends React.Component {
  componentWillMount () {
    this.state = { editingTerms: false};
    this.props.dispatch(loadSupplier(this.props.params.id));
    this.props.dispatch(loadSeasons());
  }

  render() {
    return (
      <div className="suppliers_edit" style={{ marginTop: '70px' }}>
        <div className="col-xs-6">
          <SuppliersForm title="Edit Supplier"
                         submitText="Save"
                         supplier={this.props.supplier}
                         onSubmitSupplier={this.handleOnEditSupplier.bind(this)} />
        </div>

        <div className="col-xs-6">
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">Default Terms</h3>
            </div>
            <div className="panel-body">
              {this.renderTerms()}
            </div>
          </div>
          <SupplierContacts supplier={this.props.supplier}
                            onEditContact={this.handleOnSaveContact.bind(this)}
                            onAddContact={this.handleOnSaveContact.bind(this)}/>
        </div>
      </div>
    );
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
