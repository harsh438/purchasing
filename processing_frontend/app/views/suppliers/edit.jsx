import React from 'react';
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import SuppliersForm from './_form';
import { SupplierAddContact } from './_contact';
import { loadSupplier, editSupplier, addSupplierContact } from '../../actions/suppliers';
import { SupplierContacts } from './contacts';

class SuppliersEdit extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSupplier(this.props.params.id));
  }

  render() {
    return (
      <div className="suppliers_edit" style={{ marginTop: '70px' }}>
        <div className="col-xs-5 pull-left">
          <SuppliersForm submitText="Save"
                         supplier={this.props.supplier}
                         onSubmitSupplier={this.handleOnEditSupplier.bind(this)} />
        </div>
        <div className="col-xs-5">
          <SupplierAddContact supplier={this.props.supplier} onAddContact={this.handleOnAddContact.bind(this)}/>
          <SupplierContacts supplier={this.props.supplier} />
        </div>
      </div>
    );
  }

  handleOnAddContact(contact) {
    this.props.dispatch(addSupplierContact(this.props.supplier, contact));
  }

  handleClickEditSupplier(id) {
    this.props.history.pushState(null, `/suppliers/${id}/edit`);
  }

  handleOnEditSupplier(supplier) {
    this.props.dispatch(editSupplier(supplier));
  }
}

function applyState({ supplier }) {
  return supplier;
}

export default connect(applyState)(SuppliersEdit);
