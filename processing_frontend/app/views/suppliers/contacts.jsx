import React from 'react';
import { map } from 'lodash';

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
    var contacts = this.props.contacts || [{},{}];
    return map(contacts, (contact, i) => {
      return (
        <li style={{ 'listStyleType': 'none' }} key={i}>
          <div className="panel panel-default">
            <div className="panel-body">
              <table className="table">
                <tbody>
                  <tr>
                    <th>Name</th>
                    <td>{ contact.name }</td>
                  </tr>
                  <tr>
                    <th>Title</th>
                    <td>{ contact.title }</td>
                  </tr>
                  <tr>
                    <th>Phone</th>
                    <td>{ contact.phone }</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </li>);
    })
  }
}
