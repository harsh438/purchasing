import React from 'react';
import { map } from 'lodash';
import { assign } from 'lodash';
import SupplierContactForm from './_form';
import { addSupplierContact } from '../../actions/suppliers';

export default class SupplierContacts extends React.Component {
  componentWillMount() {
    this.state = { addingContact: false, editingContact: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ addingContact: false, editingContact: false });
  }

  render() {
    return (
      <div>
        {this.renderContactAdd()}
        {this.renderContacts()}
      </div>
    );
  }

  renderContactAdd() {
    if (this.state.addingContact) {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Add Contact</h3>
          </div>
          <div className="panel-body">
            <SupplierContactForm submitText="Add contact"
                                 submittingText="Adding contact..."
                                 contact={{}}
                                 onSubmitContact={this.props.onAddContact} />
          </div>
        </div>
      );
    } else {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Contacts</h3>
          </div>
          <div className="panel-body">
            <div style={{ marginBottom: '10px'}}>
              {this.renderContactsText()}

              <button className="btn btn-success"
                      onClick={() => this.setState({ addingContact: true })}>
                Add new contact
              </button>
            </div>
          </div>
        </div>
      );
    }
  }

  renderContacts() {
    return map(this.props.supplier.contacts, (contact, i) => {
      return (
        <li style={{ listStyleType: 'none' }} key={contact.id}>
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">{contact.name}</h3>
            </div>

            <div className="panel-body">
              {this.renderContact(contact)}
            </div>
          </div>
        </li>
      );
    });
  }

  renderContact(contact) {
    if (this.state.editingContact === contact.id) {
      return (
        <SupplierContactForm submitText="Save contact"
                             submittingText="Saving contact..."
                             contact={contact}
                             onSubmitContact={this.props.onEditContact} />
      );
    }

    return (
      <div>
        <table className="table" style={{ tableLayout: 'fixed' }}>
          <tbody>
            <tr>
              <th>Title</th>
              <td>{contact.title}</td>

              <th>Mobile</th>
              <td>{contact.mobile}</td>
            </tr>

            <tr>
              <th>Email</th>
              <td>{contact.email}</td>

              <th>Landline</th>
              <td>{contact.landline}</td>
            </tr>
          </tbody>
        </table>

        <button className="btn btn-success"
                onClick={() => this.setState({ editingContact: contact.id })}>
          Edit contact
        </button>
      </div>
    );
  }

  renderContactsText() {
    if (this.props.supplier.contacts.length === 0) {
      return (
        <p>
          <em>No contacts for this supplier</em>
        </p>
      );
    }
  }
}
