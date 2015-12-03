import React from 'react';
import { map } from 'lodash';
import { assign } from 'lodash';
import SupplierContact from './_form';
import { addSupplierContact } from '../../actions/suppliers';
import SupplierAddContact from '../suppliers_contacts/_add';

export default class SupplierContacts extends React.Component {
  componentWillMount() {
    this.state = {addingContact: false};
  }

  componentWillReceiveProps(nextProps) {
    this.setState({addingContact: false});
  }

  render() {
    return (
      <div>
        {this.renderAddContact()}
        <ul style={{ padding: '0px' }}>
          {this.renderContacts()}
        </ul>
      </div>
    );
  }

  renderContacts() {
    if (this.state.addingContact) return;

    const contacts = ((this.props.supplier || {}).contacts || []).reverse();

    if (contacts.length === 0) {
      return (
        <em>No contacts for this supplier</em>
      );
    }

    return map(contacts, (contact, i) => {
      return (
        <li style={{ 'listStyleType': 'none' }} key={contact.id}>
          <SupplierContact submitText="Edit Contact" contact={contact} onSubmitContact={this.props.onEditContact} />
        </li>
      );
    })
  }

  renderAddContact() {
    if (this.state.addingContact) {
      return (
        <SupplierAddContact supplier={this.props.supplier}
                            onAddContact={this.props.onAddContact} />
      );
    } else {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">{this.renderTitle()}</h3>
          </div>
          <div className="panel-body">
            <div style={{ marginBottom: '10px'}}>
              <button className="btn btn-success"
                      onClick={this.enableAddContact.bind(this)}>
                Add new contact
              </button>
            </div>
          </div>
        </div>
      );
    }
  }

  renderTitle() {
    if (this.state.addingContact) {
      return 'Add Contact';
    } else {
      return 'Contacts';
    }
  }

  enableAddContact() {
    this.setState({ addingContact: true });
  }
}
