import React from 'react';

export default class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = {contact: this.props.contact, onSubmitCalled: false};
  }

  componentWillReceiveProps(nextProps) {
    this.setState({onSubmitCalled: false});
  }


  render () {
    return (
      <form onChange={this.handleFormChange.bind(this)}>
        <table className="table">
          <tbody>
            <tr>
              <th>Name</th>
              <td><input name="name" className="form-control" value={ this.state.contact.name } /></td>
            </tr>
            <tr>
              <th>Title</th>
              <td>
                <select name="title" className="form-control" value={ this.state.contact.title }>
                  <option value="Sales Rep">Sales Rep</option>
                  <option value="Country Manager">Country Manager</option>
                  <option value="Regional Sales Director">Regional Sales Director</option>
                  <option value="Global Sales Director">Global Sales Director</option>
                  <option value="Regional CS Rep">Regional CS Rep</option>
                  <option value="Regional Accounting Rep">Regional Accounting Rep</option>
                </select>

              </td>
            </tr>
            <tr>
              <th>Mobile</th>
              <td><input name="mobile" className="form-control" value={ this.state.contact.mobile } /></td>
            </tr>
            <tr>
              <th>Landline</th>
              <td><input name="landline" className="form-control" value={ this.state.contact.landline } /></td>
            </tr>
            <tr>
              <th>Email</th>
              <td><input name="email" className="form-control" value={ this.state.contact.email } /></td>
            </tr>
            <tr>
              <td></td>
              <td><input type="button" className="btn btn-success" value={ this.props.submitText }
                         onClick={ this.onSubmitButton.bind(this) }
                         disabled={this.state.onSubmitCalled} /></td>
            </tr>
          </tbody>
        </table>
      </form>);
  }

  onSubmitButton() {
    this.setState({onSubmitCalled: true});
    this.props.onSubmitContact(this.state.contact);
  }

  handleFormChange ({ target }) {
    this.state.contact[target.name] = target.value;
    this.setState({contact: this.state.contact});
  }
}
