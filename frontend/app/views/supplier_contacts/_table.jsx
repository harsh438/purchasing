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
        <SupplierContactForm contact={{}}
                             onFormSubmit={this.props.onContactAdd}
                             submitText="Add contact"
                             submittingText="Adding contact..." />
      );
    } else {
      return (
        <div className="clearfix"
             style={{ marginBottom: '10px' }}>
          {this.renderContactsText()}

          <button className="btn btn-success pull-right"
                  onClick={() => this.setState({ addingContact: true })}>
            Add new contact
          </button>
        </div>
      );
    }
  }

  renderContacts() {
    if (this.state.addingContact) return;

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
    if (this.state.addingContact) return;

    if (this.state.editingContact === contact.id) {
      return (
        <SupplierContactForm contact={contact}
                             onFormSubmit={this.props.onContactEdit}
                             submitText="Save contact"
                             submittingText="Saving contact..." />
      );
    }

    return (
      <div>
        <table className="table table-hover" style={{ tableLayout: 'fixed' }}>
          <tbody>
            <tr>
              <th style={{ width: '15%' }}>Title</th>
              <td>{contact.title}</td>

              <th style={{ width: '15%' }}>Category</th>
              <td>{contact.category}</td>
            </tr>

            <tr>
              <th style={{ width: '15%' }}>Email</th>
              <td>{contact.email}</td>

              <th style={{ width: '15%' }}>Landline</th>
              <td>{contact.landline}</td>
            </tr>

            <tr>
              <th style={{ width: '15%' }}>Mobile</th>
              <td>{contact.mobile}</td>

              <th style={{ width: '15%' }}></th>
              <td></td>
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
        <p className="pull-left">
          <em>No contacts for this supplier</em>
        </p>
      );
    }
  }
}
