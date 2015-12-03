import React from 'react';
import { assign } from 'lodash';

export default class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = { contact: this.props.contact,
                   onSubmitCalled: false,
                   editable: this.props.editableByDefault || false };
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
        <input name={elementName}
               className="form-control"
               value={this.state.contact[elementName]} />
      );
    } else {
      return (
        <span>{this.state.contact[elementName]}</span>
      );
    }
  }

  renderTitleElement() {
    if (this.state.editable) {
      return (
        <select name="title"
                className="form-control"
                value={this.state.contact.title}>
          <option value="Sales Rep">Sales Rep</option>
          <option value="Country Manager">Country Manager</option>
          <option value="Regional Sales Director">Regional Sales Director</option>
          <option value="Global Sales Director">Global Sales Director</option>
          <option value="Regional CS Rep">Regional CS Rep</option>
          <option value="Regional Accounting Rep">Regional Accounting Rep</option>
        </select>
      );
    } else {
      return (
        <span>{this.state.contact.title}</span>
      );
    }
  }

  renderPanelTitle() {
    if (this.state.editable) {
      return this.props.submitText;
    } else {
      return (this.state.contact.name || (<i>No Name</i>));
    }
  }

  renderNameElement() {
    if (this.state.editable) {
      return (
        <tr>
          <th>Name</th>
          <td colSpan="3">{this.renderElement('name')}</td>
        </tr>
      );
    }
  }

  render () {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">{this.renderPanelTitle()}</h3>
        </div>
        <div className="panel-body">
          <form onChange={this.handleFormChange.bind(this)}>
            <table className="table" style={{ tableLayout :'fixed' }}>
              <tbody>
                {this.renderNameElement()}
                <tr>
                  <th>Title</th>
                  <td>{this.renderTitleElement()}</td>
                  <th>Mobile</th>
                  <td>{this.renderElement('mobile')}</td>
                </tr>
                <tr>
                  <th>Email</th>
                  <td>{this.renderElement('email')}</td>
                  <th>Landline</th>
                  <td>{this.renderElement('landline')}</td>
                </tr>
              </tbody>
            </table>
              <input type="button"
                     className="btn btn-success"
                     value={this.props.submitText}
                     onClick={this.onSubmitButton.bind(this)}
                     disabled={this.state.onSubmitCalled} />
          </form>
        </div>
      </div>
    );
  }

  onSubmitButton() {
    if (this.state.editable) {
      this.setState({ onSubmitCalled: true });
      this.props.onSubmitContact(this.state.contact);
    } else {
      this.setState({ editable: true });
    }
  }

  handleFormChange ({ target }) {
    const contact = assign({}, this.state.contact, { [target.name]: target.value });
    this.setState({ contact });
  }
}
