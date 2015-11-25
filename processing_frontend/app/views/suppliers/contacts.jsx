import React from 'react';
import { map } from 'lodash';
import { assign } from 'lodash';

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
    //console.log(this.state.supplier,contact);
    //this.props.dispatch(addSupplierContact(supplier));
  }
}

export class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = { contact: this.props.contact || {} };
  }

  render () {
    return (<div className="panel panel-default">
      <div className="panel-body">
      <form onChange={this.handleFormChange.bind(this)}>
        <table className="table">
          <tbody>
            <tr>
              <th>Name</th>
              <td><input className="form-control" value={ this.state.contact.name } /></td>
            </tr>
            <tr>
              <th>Title</th>
              <td><input className="form-control" value={ this.state.contact.title } /></td>
            </tr>
            <tr>
              <th>Mobile</th>
              <td><input className="form-control" value={ this.state.contact.mobile } /></td>
            </tr>
            <tr>
              <th>Landline</th>
              <td><input className="form-control" value={ this.state.contact.landline } /></td>
            </tr>
            <tr>
              <th>Email</th>
              <td><input className="form-control" value={ this.state.contact.email } /></td>
            </tr>
            <tr>
              <td></td>
              <td><input type="button" className="btn btn-primary" value={ this.props.submitText }
                         onClick={ () => this.props.onSubmitContact(this.state.contact) }/></td>
            </tr>
          </tbody>
        </table>
      </form>
    </div>
    </div>);
  }

  handleFormChange () {

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
