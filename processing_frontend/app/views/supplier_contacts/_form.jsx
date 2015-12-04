import React from 'react';
import { assign } from 'lodash';

export default class SupplierContactForm extends React.Component {
  componentWillMount() {
    this.state = { contact: this.props.contact,
                   submitting: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
  }

  render () {
    return (
      <form onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <table className="table" style={{ tableLayout: 'fixed' }}>
          <tbody>
            <tr>
              <th>
                <label htmlFor="contactName">Name</label>
              </th>
              <td colSpan="3">
                <input id="contactName"
                       name="name"
                       value={this.state.contact.name}
                       className="form-control"
                       required />
              </td>
            </tr>

            <tr>
              <th>
                <label htmlFor="contactTitle">Title</label>
              </th>
              <td>
                <select name="title"
                        className="form-control"
                        required
                        value={this.state.contact.title}>
                  <option value=""> -- choose title -- </option>
                  <option value="Sales Rep">Sales Rep</option>
                  <option value="Country Manager">Country Manager</option>
                  <option value="Regional Sales Director">Regional Sales Director</option>
                  <option value="Global Sales Director">Global Sales Director</option>
                  <option value="Regional CS Rep">Regional CS Rep</option>
                  <option value="Regional Accounting Rep">Regional Accounting Rep</option>
                </select>
              </td>

              <th>
                <label htmlFor="contactMobile">Mobile</label>
              </th>
              <td>
                <input id="contactMobile"
                       name="mobile"
                       value={this.state.contact.mobile}
                       className="form-control" />
              </td>
            </tr>

            <tr>
              <th>
                <label htmlFor="contactEmail">Email</label>
              </th>
              <td>
                <input id="contactEmail"
                       name="email"
                       value={this.state.contact.email}
                       className="form-control" />
              </td>

              <th>
                <label htmlFor="contactMobile">Landline</label>
              </th>
              <td>
                <input id="contactLandline"
                       name="landline"
                       value={this.state.contact.landline}
                       className="form-control" />
              </td>
            </tr>
          </tbody>
        </table>

        <button className="btn btn-success"
                disabled={this.state.submitting}>
          {this.submitText()}
        </button>
      </form>
    );
  }

  submitText() {
    if (this.state.submitting) {
      return this.props.submittingText;
    } else {
      return this.props.submitText;
    }
  }

  handleFormChange ({ target }) {
    const contact = assign({}, this.state.contact, { [target.name]: target.value });
    this.setState({ contact });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFormSubmit(this.state.contact);
  }
}
