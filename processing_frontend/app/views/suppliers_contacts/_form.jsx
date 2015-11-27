import React from 'react';

export default class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = {contact: this.props.contact, onSubmitCalled: false, editable: this.props.editableByDefault || false};
  }

  componentWillReceiveProps(nextProps) {
    this.setState({onSubmitCalled: false});
    if (!(this.props.editableByDefault)) {
      this.setState({editable: false});
    }
  }

  renderElement(elementName) {
    if (this.state.editable) {
      return (

        <input name={elementName} className="form-control" value={ this.state.contact[elementName] } />

        );
    } else {
      return (<span>{ this.state.contact[elementName] } </span>)
    }
  }

  renderTitleElement() {
    if (this.state.editable) {
      return (
        <select name="title" className="form-control" value={ this.state.contact.title }>
          <option value="Sales Rep">Sales Rep</option>
          <option value="Country Manager">Country Manager</option>
          <option value="Regional Sales Director">Regional Sales Director</option>
          <option value="Global Sales Director">Global Sales Director</option>
          <option value="Regional CS Rep">Regional CS Rep</option>
          <option value="Regional Accounting Rep">Regional Accounting Rep</option>
        </select>
      )
    } else {
      return (<span>{ this.state.contact.title } </span>)
    }
  }

  render () {
    return (
      <form onChange={this.handleFormChange.bind(this)}>
        <table className="table" style={ {'tableLayout':'fixed'} }>
          <tbody>
            <tr>
              <th>Name</th>
              <td>{ this.renderElement('name') }</td>
              <th>Mobile</th>
              <td>{ this.renderElement('mobile') }</td>
            </tr>
            <tr>
              <th>Title</th>
              <td>{ this.renderTitleElement() }</td>
              <th>Landline</th>
              <td>{ this.renderElement('landline') }</td>
            </tr>
            <tr>
              <th>Email</th>
              <td>{ this.renderElement('email') }</td>
              <td><input type="button" className="btn btn-success" value={ this.props.submitText }
                         onClick={ this.onSubmitButton.bind(this) }
                         disabled={this.state.onSubmitCalled} /></td>
              <td></td>

            </tr>
          </tbody>
        </table>
      </form>);
  }

  onSubmitButton() {
    if (this.state.editable) {
      this.setState({onSubmitCalled: true});
      this.props.onSubmitContact(this.state.contact);
    } else {
      this.setState({editable: true});
    }
  }

  handleFormChange ({ target }) {
    this.state.contact[target.name] = target.value;
    this.setState({contact: this.state.contact});
  }
}
