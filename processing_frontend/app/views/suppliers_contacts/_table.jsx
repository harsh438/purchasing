import React from 'react';
import { map } from 'lodash';
import { assign } from 'lodash';
import SupplierContact from './_form';
import { addSupplierContact } from '../../actions/suppliers';

export default class SupplierContacts extends React.Component {
  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Contacts</h3>
        </div>
        <div className="panel-body">
          <ul style={{ padding: '0px' }}>
            { this.renderContacts() }
          </ul>
        </div>
      </div>
    )
  }

  renderContacts() {
    var contacts = ((this.props.supplier || {}).contacts || []).reverse();
    if (contacts.length === 0) {
      return <i>No contacts for this supplier</i>
    }
    return map(contacts, (contact, i) => {
      return (
        <li style={{ 'listStyleType': 'none' }} key={contact.id}>
          <SupplierContact submitText="Edit Contact" contact={contact} onSubmitContact={this.props.onEditContact} />
        </li>);
    })
  }
}


