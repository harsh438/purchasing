import React from 'react';
import { map } from 'lodash';
import { assign } from 'lodash';
import { addSupplierContact } from '../../actions/suppliers';

export class SupplierAddContact extends React.Component {
  componentWillMount() {
    this.state = assign({contact: {}}, this.props.supplier);
  }

  render() {
    return (<div className="panel panel-default">
              <div className="panel-heading">
                <h3 className="panel-title">Add Contact</h3>
              </div>
              <div className="panel-body">
                <SupplierContact submitText="Add Contact"
                                 contact={this.state.contact}
                                 onSubmitContact={this.handleAddContact.bind(this)} />
              </div>
            </div>
    );
  }

  handleAddContact(contact) {
    console.log('addContract', contact);
    addSupplierContact(this.props.supplier, contact);
  }
}

export class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = this.props.contact || {};
  }

  render () {
    return (<div className="panel panel-default">
      <div className="panel-body">
      <form onChange={this.handleFormChange.bind(this)}>
        <table className="table">
          <tbody>
            <tr>
              <th>Name</th>
              <td><input name="name" className="form-control" value={ this.state.name } /></td>
            </tr>
            <tr>
              <th>Title</th>
              <td><input name="title" className="form-control" value={ this.state.title } /></td>
            </tr>
            <tr>
              <th>Mobile</th>
              <td><input name="mobile" className="form-control" value={ this.state.mobile } /></td>
            </tr>
            <tr>
              <th>Landline</th>
              <td><input name="landline" className="form-control" value={ this.state.landline } /></td>
            </tr>
            <tr>
              <th>Email</th>
              <td><input name="email" className="form-control" value={ this.state.email } /></td>
            </tr>
            <tr>
              <td></td>
              <td><input type="button" className="btn btn-success" value={ this.props.submitText }
                         onClick={ () => this.props.onSubmitContact(this.state) }/></td>
            </tr>
          </tbody>
        </table>
      </form>
    </div>
    </div>);
  }

  handleFormChange ({ target }) {
    this.setState({ [target.name]: target.value });
  }
}

export class SupplierContacts extends React.Component {
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
    var contacts = (this.props.supplier || {}).contacts || [];
    contacts = [];
    if (contacts.length === 0) {
      return <b>No Contacts for this supplier</b>
    }
    return map(contacts, (contact, i) => {
      return (
        <li style={{ 'listStyleType': 'none' }} key={i}>
          <SupplierContact submitText="Edit Contact" contact={contact} />
        </li>);
    })
  }
}
